--=================================================
--	Заполнение таблицы Skills значениями
--=================================================

rollback;

begin;

set transaction isolation level Serializable;

insert into Skills (SkillName, Category) values
-- Языки программирования
('JavaScript', 'Programming Language'),
('Python', 'Programming Language'),
('Java', 'Programming Language'),
('C#', 'Programming Language'),
('C++', 'Programming Language'),
('PHP', 'Programming Language'),
('Go', 'Programming Language'),
('TypeScript', 'Programming Language'),
('Ruby', 'Programming Language'),
('Swift', 'Programming Language'),
('Kotlin', 'Programming Language'),
('Rust', 'Programming Language'),
('Scala', 'Programming Language'),
('R', 'Programming Language'),
('Dart', 'Programming Language'),

-- Фронтенд-разработка
('React', 'Frontend'),
('Angular', 'Frontend'),
('Vue.js', 'Frontend'),
('Svelte', 'Frontend'),
('HTML5', 'Frontend'),
('CSS3', 'Frontend'),
('SASS/SCSS', 'Frontend'),
('Tailwind CSS', 'Frontend'),
('Bootstrap', 'Frontend'),
('Webpack', 'Frontend'),
('Vite', 'Frontend'),

-- Бэкенд-разработка
('Node.js', 'Backend'),
('Express.js', 'Backend'),
('Django', 'Backend'),
('Flask', 'Backend'),
('Spring Boot', 'Backend'),
('.NET Core', 'Backend'),
('Laravel', 'Backend'),
('Ruby on Rails', 'Backend'),
('FastAPI', 'Backend'),
('GraphQL', 'Backend'),

-- Базы данных
('PostgreSQL', 'Database'),
('MySQL', 'Database'),
('MongoDB', 'Database'),
('Redis', 'Database'),
('SQLite', 'Database'),
('Oracle', 'Database'),
('SQL Server', 'Database'),
('Firebase', 'Database'),
('Elasticsearch', 'Database'),
('Cassandra', 'Database'),

-- DevOps
('Docker', 'DevOps'),
('Kubernetes', 'DevOps'),
('AWS', 'DevOps'),
('Azure', 'DevOps'),
('Google Cloud', 'DevOps'),
('Terraform', 'DevOps'),
('Ansible', 'DevOps'),
('Jenkins', 'DevOps'),
('GitHub Actions', 'DevOps'),
('Prometheus', 'DevOps'),
('Grafana', 'DevOps'),

-- Мобильная разработка
('React Native', 'Mobile'),
('Flutter', 'Mobile'),
('Android SDK', 'Mobile'),
('iOS Development', 'Mobile'),
('Xamarin', 'Mobile'),

-- Тестирование
('Jest', 'Testing'),
('Cypress', 'Testing'),
('Selenium', 'Testing'),
('JUnit', 'Testing'),
('pytest', 'Testing'),
('Postman', 'Testing'),
('Load Testing', 'Testing'),

-- Другие технологии
('Git', 'Version Control'),
('Linux', 'Operating Systems'),
('Bash Scripting', 'Scripting'),
('REST API', 'API Development'),
('Microservices', 'Architecture'),
('Blockchain', 'Emerging Tech'),
('Machine Learning', 'AI/ML'),
('TensorFlow', 'AI/ML'),
('PyTorch', 'AI/ML'),
('Unity', 'Game Development'),
('Unreal Engine', 'Game Development'),
('Web3', 'Blockchain'),
('Solidity', 'Blockchain'),
('Cybersecurity', 'Security'),
('Ethical Hacking', 'Security'),

-- Методологии
('Agile', 'Methodology'),
('Scrum', 'Methodology'),
('Kanban', 'Methodology'),
('CI/CD', 'Methodology'),
('DevSecOps', 'Methodology'),
('TDD', 'Methodology');

commit;