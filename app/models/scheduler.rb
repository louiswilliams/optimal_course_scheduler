class Scheduler
	attr_reader :week

	def initialize(schedule)
		@schedule = schedule
		@courses = []
		ScheduleCourse.where("schedule_id = ?",@schedule.id).each do |sc|
			@courses << Course.find(sc.course)
		end
		
		@week = Scheduler.week
	end

	def week
		return @week
	end

	def run c, s=0
		c_scheduled = false
		if c <courses.size
			s_scheduled = false;
			sections = Section.where("course_id = ?",courses[c].id)
			s_tmp = s
			while s_tmp <sections.size && !s_scheduled
				s_scheduled = place_section s_tmp
				s_tmp.next
			end
			if !s_scheduled
				if c>0
					c.pred
					s.next
					if s==sections.size
						c.pred
						s=0
					end
				else
					return false
				end
			else
				c.next
				s=0
			end
			c.run c, s
		else
			return true
		end
	end

	# def place_course c, s=0
	# 	s_scheduled = false;
	# 	sections = Section.where("course_id = ?",courses[c].id)
	# 	while s <sections.size && !s_scheduled
	# 		place_section s
	# 	end
	# 	if !s_scheduled
	# 		c.pred
	# 	end
	# end

	def place_section s
		m=0
		m_scheduled = false
		meetings = Meeting.where("section_id = ?",sections[s].id)
		while m <sections.size && !m_scheduled
			if !schedule meetings[m]
				m_scheduled = false
			end
			m.next
		end
		if !m_scheduled
			s.next
		end
	end
	# private
	# def place_course course
	# 	sections = Section.where("course_id = ?",course.id)
	# 	sections.each do |section|
	# 		place_section section
	# 	end
	# end

	# def place_section section
	# 	meetings = Meeting.where("section_id = ?",section.id)
	# 	meetings.each do |meeting|
	# 		if !place_meeting meeting
	# 			return false
	# 		end
	# 	end
	# 	return true
	# end

	# def place_meeting meeting
	# 	placeable = true;
	# 	Scheduler.days.each do |day|
	# 		if meeting.send(day) && placeable
	# 			times = @week[day]

	# 			start_time = Scheduler.time_to_float(Scheduler.round_time(meeting.start_time))
	# 			end_time = Scheduler.time_to_float(Scheduler.round_time(meeting.end_time))
	# 			length = (end_time - start_time)

	# 			placeable = place_test times,start_time,length
				
	# 		end
	# 			# placeable = place_test meeting, start_time, length
	# 	end
	# 	if placeable

	# 	end
	# 	return true
	# end

	# def test_consistency times,start_time,length
	# 	pass_test = true
	# 	times.each do |time|
	# 		if (time[0] == start_time) && pass_test
	# 			pass_test = (time[1] == false)
	# 			# Rails.logger.info "#{time[0]},#{time[1]}: #{pass_test}"
	# 		else
	# 			pass_test = false
	# 		end
	# 	end
	# end

	class << self
		def days
			return  [:monday,:tuesday, :wednesday, :thursday, :friday]
		end
		
		def times
			# This is wierd. I need to map every half hour
			return Hash[(16..44).map { |n| [n/2.0,false] } ]
		end

		def week
			week = Hash.new
			days.each do |day|
				week[day] = times
			end
			return week
			# return Hash[days.map {|d| [:times,times]}]
		end

		def day_to_str day, w = true
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
			sup = time_t.strftime("%k").to_i
			inf = (time_t.strftime("%M").to_i == 0) ? 0 : 0.5
			return sup + inf
		end

		def round_time t
			if t.instance_of? Time
				return t.round(30.minutes)
			else
				return Time.parse(float_time_to_str t).round(30.minutes)
			end
		end
	end
end

