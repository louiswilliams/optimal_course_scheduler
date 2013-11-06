class Scheduler
	attr_reader :week

	def initialize schedule
		@schedule = schedule
		tmp_courses = Array.new
		@courses = Array.new
		@week = Scheduler.week
		
		@schedule.schedule_courses.each do |sc|
			tmp_courses << sc.course
		end

		tmp_courses.sort! { |a,b| a.sections.count <=> b.sections.count }
        tmp_courses.each do |course|
            @courses << ScheduledCourse.new(course,self)
        end

		week_iterate { |day,time,slot|
			@schedule.time_constraints.each do |tc|
				days_str = tc.days_to_str

				class_time = Scheduler.time_to_float Scheduler.round_time(tc.start_time)
				on_this_day = (days_str.include?(Scheduler.day_to_str(day))) ? true : false

				if class_time==time && on_this_day
					current_time = class_time

					while current_time < Scheduler.time_to_float(tc.end_time)
						@week[day][current_time] = tc
						current_time += 0.5
					end
				end
			end
		}
	end

	def week_iterate
		Scheduler.days.each do |day|
			@week[day].each do |(time,slot)|
				yield day,time,slot
			end
		end
	end

	def run
		index = 0
		while index < @courses.count 
            Rails.logger.info "INDEX: #{index}"
			if @courses[index].schedule
                Rails.logger.info "Course scheduled: true"
				index += 1
				if index==@courses.count
					return true
				end
			elsif index == 0
				return false
			else
				if @courses[index].has_next
					@courses[index].revert
					index -= 1
					@courses[index].next
				else
					return false
				end
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
	        Rails.logger.info "#{@course.id}"
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

		def has_next
			return @section_index+1 < @sections.count
		end

		def pred
			@section_index -= 1
		end

		def revert
			@sections[@section_index].revert
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
	        Rails.logger.info "Section scheduled: #{schedulable}"
	        if !schedulable
	            revert
	        end
			return schedulable
		end

		def revert
		    Rails.logger.info "Reverting section #{@section.name}"
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

			@scheduler.week_iterate do |day,time,slot|
				days_str = @meeting.days_to_str

				class_time = Scheduler.time_to_float Scheduler.round_time(@meeting.start_time)
				on_this_day = (days_str.include?(Scheduler.day_to_str(day))) ? true : false

				if class_time==time && on_this_day
					current_time = class_time
					Rails.logger.info "#{day}, #{class_time}, #{@meeting.section.course.name}, #{@meeting.section.name}"				

					while schedulable && current_time <= Scheduler.time_to_float(@meeting.end_time)
						if @scheduler.week[day][current_time] != false
							schedulable = false
						else
                            hold = {:day => day, :time => current_time, :meeting =>  @meeting }
                            @holds << hold
                            Rails.logger.info "Holding: #{day}, #{current_time}"
							@scheduler.week[day][current_time] = @meeting
							current_time += 0.5
						end
					end
				end
			end

	        Rails.logger.info "Meeting scheduled: #{schedulable}"
			return schedulable
		end
		
		def revert
			@holds.each do |hold|
	            Rails.logger.info "Revering hold #{hold[:day]}, #{hold[:time]}"
				@scheduler.week[hold[:day]][hold[:time]] = false
			end
		end
	end
end