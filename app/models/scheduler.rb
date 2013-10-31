class Scheduler
	attr_reader :week

	def initialize schedule
		@schedule = schedule
		@courses = []
		@schedule.schedule_courses.each do |sc|
			@courses << ScheduledCourse.new(sc.course,self)
		end
		
		@week = Scheduler.week
	end

	def run
		index = 0
		while index < @courses.count 
			if @courses[index].schedule
				index += 1
				if index==@courses.count
					return true
				end
			elsif index == 0
				return false
			else
				@courses[index].revert
				index -= 1
				@courses[index].next
			end
		end

	end

	class << self
		def days
			return  [:monday,:tuesday, :wednesday, :thursday, :friday]
		end
		
		def times
			# This is wierd. I need to map every half hour
			f_times = Hash[(16..44).map { |n| [n/2.0,false] } ]
			return f_times
		end

		def week
			week = Hash.new
			days.each do |day|
				week[day] = times
			end
			return week
		end

		def day_to_str day, w = false
			case day
			when :monday
				return (w) ? "Monday" : "M"
			when :tuesday
				return (w) ? "Tuesday" : "T"
			when :wednesday
				return (w) ? "Wednesday" : "W"
			when :thursday
				return (w) ? "Thursday" : "R"
			when :friday
				return (w) ? "Friday" : "F"
			else
				return nil
			end
		end

		def float_time_to_str time_f
			mins = (time_f % 1 == 0) ? "00" : "30"
			hour = time_f.to_i.to_s
			hour = (hour.length==1) ? "0" + hour : hour
			return hour + ":" + mins
		end

		def time_to_float time_t
			sup = time_t.hour
			inf = (time_t.min == 0) ? 0.0 : 0.5
			return sup + inf
		end

		def float_time_to_time time_f
			Time.parse(float_time_to_str time_f)
		end

		def round_time t
			if !t.instance_of? Time
				t = float_time_to_time t 
			end
			sec = 30.minutes

			down = t - (t.to_i % sec)
			up = down + sec
			if (t - down < up - t)
				return down
			else
				return up
			end
		end
	end
end

class ScheduledCourse
	attr_reader :course, :sections

	def initialize course, scheduler
		@course = course
		@sections = []
		@course.sections.each do |section|
			@sections << ScheduledSection.new(section, scheduler)
		end
		@section_index = 0
	end

	def schedule
		scheduled = false
		while ( !scheduled && @section_index < @sections.count )
			scheduled = @sections[@section_index].schedule
			if !scheduled
				@section_index += 1
			end
		end
		return scheduled
	end

	def next
		@section_index += 1
	end

	def pred
		@section_index -= 1
	end

	def revert
		Rails.logger.info "#{@section_index}, #{@sections[@section_index]}"
		# @sections[@section_index].revert
	end
end

class ScheduledSection
	attr_reader :section, :meetings

	def initialize section, scheduler
		@section = section
		@meetings = []
		@section.meetings.each do |meeting|
			@meetings << ScheduledMeeting.new(meeting, scheduler)
		end

	end

	def schedule
		schedulable = true
		index = 0 
		while schedulable && index < @meetings.count 
			if !@meetings[index].schedule
				schedulable = false
			end
			index += 1
		end
		return schedulable
	end

	def revert
		@meetings.each do |meeting|
			meeting.revert
		end
	end
end

class ScheduledMeeting
	attr_reader :meeting

	def initialize meeting, scheduler
		@meeting = meeting
		@scheduler = scheduler
		@holds = Array.new
	end
	def schedule
		schedulable = true

		Scheduler.days.each do |day|
			days_str = @meeting.days_to_str

			@scheduler.week[day].each do |(time,slot)|

				class_time = Scheduler.time_to_float Scheduler.round_time(@meeting.start_time)
				on_this_day = (days_str.include?(Scheduler.day_to_str(day))) ? true : false

				if class_time==time && on_this_day
					current_time = class_time
					Rails.logger.info "#{day}, #{class_time}, #{time}, #{@meeting.section.course.name}"				

					while schedulable && current_time <= Scheduler.time_to_float(@meeting.end_time)
						if @scheduler.week[day][current_time] != false
							schedulable = false
						else
							@holds << {:day => day, :time => time, :meeting =>  @meeting }
							@scheduler.week[day][current_time] = @meeting
							current_time += 0.5
						end
					end
				end
			end
		end
		return schedulable
	end
	
	def revert
		@holds.each do |hold|
			@scheduler.week[hold[:day]][hold[:time]] = false
		end 
	end


end