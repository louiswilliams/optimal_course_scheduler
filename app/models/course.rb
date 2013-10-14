class Course < ActiveRecord::Base
  has_many :sections
  def self.colleges
    {'ACCT' => 'Accounting',
'AERO' => 'Aerospace Engineering',
'AE' => 'Aerospace Engineering',
'AS' => 'Air Force Aerospace Studies',
'APPH' => 'Applied Physiology',
'ASE' => 'Applied Systems Engineering',
'ARBC' => 'Arabic',
'ARCH' => 'Architecture',
'BIOL' => 'Biology',
'BMEJ' => 'Biomed Engr/Joint Emory PKU',
'BMED' => 'Biomedical Engineering',
'BMEM' => 'Biomedical Engr/Joint Emory',
'BC' => 'Building Construction',
'CETL' => 'Center Enhancement-Teach/Learn',
'CHBE' => 'Chemical & Biomolecular Engr',
'CHEM' => 'Chemistry',
'CHIN' => 'Chinese',
'CP' => 'City Planning',
'CEE' => 'Civil and Environmental Engr',
'COA' => 'College of Architecture',
'COE' => 'College of Engineering',
'CX' => 'Computational Mod, Sim, & Data',
'CSE' => 'Computational Science & Engr',
'CS' => 'Computer Science',
'COOP' => 'Cooperative Work Assignment',
'UCGA' => 'Cross Enrollment',
'EAS' => 'Earth and Atmospheric Sciences',
'ECON' => 'Economics',
'ECE' => 'Electrical & Computer Engr',
'ENGL' => 'English',
'ENTR' => 'Enterprise Transformation',
'FS' => 'Foreign Studies',
'FREN' => 'French',
'GT' => 'Georgia Tech',
'GTL' => 'Georgia Tech Lorraine',
'GRMN' => 'German',
'HPS' => 'Health Performance Science',
'HP' => 'Health Physics',
'HS' => 'Health Systems',
'HIN' => 'Hindi',
'HIST' => 'History',
'HTS' => 'History, Technology & Society',
'ISYE' => 'Industrial & Systems Engr',
'ID' => 'Industrial Design',
'IPCO' => 'Int\'l Plan Co-op Abroad',
'IPIN' => 'Int\'l Plan Intern Abroad',
'IPFS' => 'Int\'l Plan-Exchange Program',
'IPSA' => 'Int\'l Plan-Study Abroad',
'INTA' => 'International Affairs',
'IL' => 'International Logistics',
'INTN' => 'Internship',
'IMBA' => 'Intl Executive MBA',
'JAPN' => 'Japanese',
'KOR' => 'Korean',
'LATN' => 'Latin',
'LS' => 'Learning Support',
'LING' => 'Linguistics',
'LCC' => 'Lit, Communication & Culture',
'MGT' => 'Management',
'MOT' => 'Management of Technology',
'MSE' => 'Materials Science & Engr',
'MATH' => 'Mathematics',
'ME' => 'Mechanical Engineering',
'MP' => 'Medical Physics',
'MSL' => 'Military Science & Leadership',
'ML' => 'Modern Languages',
'MUSI' => 'Music',
'NS' => 'Naval Science',
'NRE' => 'Nuclear & Radiological Engr',
'PERS' => 'Persian',
'PHIL' => 'Philosophy',
'PHYS' => 'Physics',
'POL' => 'Political Science',
'PTFE' => 'Polymer, Textile and Fiber Eng',
'DOPP' => 'Professional Practice',
'PSYC' => 'Psychology',
'PSY' => 'Psychology',
'PUBP' => 'Public Policy',
'PUBJ' => 'Public Policy/Joint GSU PhD',
'RGTR' => 'Regents\' Reading Skills',
'RGTE' => 'Regent\' Writing Skills',
'RUSS' => 'Russian',
'SCI' => 'Science',
'SOC' => 'Sociology',
'SPAN' => 'Spanish'}
  end
end
