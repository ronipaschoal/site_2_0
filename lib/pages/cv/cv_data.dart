import 'package:ronip/models/cv_item_model.dart';

/// Birth year, used to compute the age shown in the résumé header. Only the
/// year is tracked (not the full birth date), so the age simply follows the
/// current calendar year rather than the exact birthday.
const cvBirthYear = 1985;

/// The single contact email shown across the site (résumé and the home
/// page's Contact section) — kept in one place so the two never drift apart.
const contactEmail = 'ronipaschoal@gmail.com';

/// The résumé's content, shared by the on-screen [CvContentWidget] and the
/// PDF export (`CvPdfBuilder`) so both stay in sync from one source.
const cvSummary = {
  'pt': 'Desenvolvedor de software com mais de 8 anos de experiência, '
      'sendo mais de 5 em desenvolvimento mobile híbrido e mais de 3 com '
      'Flutter. Especializado em Flutter para aplicações mobile Android '
      'e iOS. '
      'Experiência em arquitetura MVVM e Clean Architecture, Design '
      'Systems, BLoC/Cubit e testes automatizados, com atuação da '
      'definição técnica à publicação de soluções escaláveis, incluindo '
      'papel fundamental na estruturação de equipe e na definição de '
      'padrões e ferramentas, além do uso de Inteligência Artificial no '
      'dia a dia de desenvolvimento. Aberto a novas oportunidades como '
      'desenvolvedor mobile Flutter.',
  'en': 'Software developer with more than 8 years of experience, including '
      'over 5 in hybrid mobile development and over 3 with Flutter. '
      'Specialized in Flutter for Android and iOS mobile applications. '
      'Experienced in '
      'MVVM and Clean Architecture, Design Systems, BLoC/Cubit, and '
      'automated testing, working from technical definition to publishing '
      'scalable solutions, including a key role in structuring the team '
      'and defining standards and tools, plus day-to-day use of '
      'Artificial Intelligence in development. Open to new opportunities '
      'as a Flutter mobile developer.',
};

const cvContactList = [
  CvContactItem(
    type: CvContactType.email,
    text: contactEmail,
    url: 'mailto:$contactEmail?subject=Contato via CV',
  ),
  CvContactItem(
    type: CvContactType.linkedin,
    text: 'linkedin.com/in/roni-paschoal',
    url: 'https://www.linkedin.com/in/roni-paschoal/',
  ),
  CvContactItem(
    type: CvContactType.github,
    text: 'github.com/ronipaschoal',
    url: 'https://github.com/ronipaschoal/',
  ),
  CvContactItem(
    type: CvContactType.website,
    text: 'ronipaschoal.com.br',
    url: 'https://ronipaschoal.com.br/',
  ),
];

const cvSkillGroupOrder = ['mobile', 'architecture', 'fullstack', 'tools'];

// Grouped by kind: packages the apps depend on sit under "mobile", workflow
// tools under "tools" — shared by the résumé, its PDF and the home bento.
const cvSkillGroups = <String, List<String>>{
  'mobile': ['Flutter', 'Dart', 'BLoC', 'Dio', 'get_it'],
  'architecture': [
    'BLoC',
    'MVVM',
    'Clean Architecture',
    'SOLID',
    'Design Patterns',
    'REST',
    'Automated Testing',
  ],
  'fullstack': ['TypeScript', 'Angular', 'React', 'Go'],
  'tools': ['Git', 'GitHub', 'GitHub Actions', 'CI/CD', 'Claude'],
};

const cvLanguageList = [
  CvLanguageItem(
    language: {'pt': 'Inglês', 'en': 'English'},
    level: {'pt': 'Nível intermediário', 'en': 'Intermediate proficiency'},
  ),
  CvLanguageItem(
    language: {'pt': 'Português', 'en': 'Portuguese'},
    level: {'pt': 'Fluente ou nativo', 'en': 'Fluent or native'},
  ),
];

const cvExperienceList = [
  CvExperienceItem(
    company: 'Mercado Livre',
    period: 'Jul/2025 - Jun/2026',
    role: {
      'pt': 'Engenheiro de Software Pleno',
      'en': 'Mid-Level Software Engineer',
    },
    description: {
      'pt': 'Atuação fullstack na evolução do backoffice (React no front-end '
          'e Go no back-end) para gestão de conteúdo do app Mercado Pago, '
          'com testes unitários e uso de Inteligência '
          'Artificial para desenvolvimento, refatoração e automação de '
          'tarefas.',
      'en': 'Worked fullstack evolving the backoffice (React front-end and Go '
          'back-end) for Mercado Pago app content management, with unit '
          'testing, and use of Artificial Intelligence for '
          'development, refactoring, and task automation.',
    },
  ),
  CvExperienceItem(
    company: 'TOTVS',
    period: 'Mar/2022 - Abr/2025',
    role: {
      'pt': 'Engenheiro de Software Móvel Flutter Sênior',
      'en': 'Senior Flutter Mobile Software Engineer',
    },
    description: {
      'pt': 'Definição e adoção do Flutter como plataforma de '
          'desenvolvimento mobile, com papel fundamental na estruturação '
          'de uma equipe de 3 pessoas e na definição da arquitetura e dos '
          'padrões técnicos. Desenvolvimento e evolução dos aplicativos '
          'Minha Comanda Eletrônica e Minha Governança '
          'Hoteleira, com arquitetura MVVM, gerenciamento de estado via '
          'BLoC/Cubit e integração a APIs REST via Dio. Criação de '
          'biblioteca de componentes baseada no Design System corporativo '
          'e de biblioteca própria para configuração de dispositivos Smart '
          'POS. Configuração e manutenção de pipelines de CI/CD, com '
          'ajustes que reduziram o tempo de execução, e configuração de '
          'acesso a bibliotecas privadas de dependência para os testes '
          'automatizados. Publicação e distribuição das aplicações para '
          'Android, iOS e diferentes modelos de Smart POS.',
      'en': 'Defined and adopted Flutter as the mobile development '
          'platform, playing a key role in structuring a team of 3 and '
          'defining the architecture and technical standards. Developed '
          'and evolved the Minha Comanda Eletrônica and Minha Governança '
          'Hoteleira apps, with MVVM architecture, '
          'state management via BLoC/Cubit, and REST API integration via '
          'Dio. Built a component library based on the corporate Design '
          'System and a proprietary library for configuring Smart POS '
          'devices. Configured and maintained CI/CD pipelines, with '
          'adjustments that reduced execution time, and set up access to '
          'private dependency libraries for automated tests. Published '
          'and distributed the applications for Android, iOS, and various '
          'Smart POS models.',
    },
  ),
  CvExperienceItem(
    company: 'TOTVS',
    period: 'Dez/2021 - Abr/2022',
    role: {
      'pt': 'Desenvolvedor Front End Pleno',
      'en': 'Mid-Level Front-End Developer',
    },
    description: {
      'pt': 'Evolução de aplicação Angular para hotelaria, com desenvolvimento '
          'de funcionalidades, correção de bugs, melhorias contínuas e '
          'ampliação da cobertura de testes automatizados.',
      'en': 'Evolved an Angular application for the hospitality industry, '
          'developing features, fixing bugs, delivering continuous '
          'improvements, and expanding automated test coverage.',
    },
  ),
  CvExperienceItem(
    company: 'Setfin',
    period: 'Set/2022 - Out/2023',
    role: {
      'pt': 'Engenheiro de Software Móvel Flutter Sênior · Freelance',
      'en': 'Senior Flutter Mobile Software Engineer · Freelance',
    },
    description: {
      'pt':
          'Definição da arquitetura da aplicação Flutter e desenvolvimento do '
              'MVP, conduzindo a evolução do produto até sua segunda versão, '
              'com arquitetura MVVM e gerenciamento de estado via BLoC/Cubit. '
              'Implementação de integrações com APIs REST via Dio e '
              'publicação da aplicação nas plataformas Android e iOS.',
      'en': "Defined the Flutter application's architecture and developed the "
          'MVP, leading the product through its second version, with MVVM '
          'architecture and state management via BLoC/Cubit. Implemented '
          'REST API integrations via Dio and published the app on Android '
          'and iOS.',
    },
  ),
  CvExperienceItem(
    company: 'Setfin',
    period: 'Set/2021 - Set/2022',
    role: {
      'pt': 'Desenvolvedor Front End Sênior · Freelance',
      'en': 'Senior Front-End Developer · Freelance',
    },
    description: {
      'pt': 'Definição da arquitetura inicial da aplicação React, '
          'desenvolvimento do MVP e estabelecimento da estrutura e dos '
          'padrões técnicos do projeto.',
      'en': "Defined the React application's initial architecture, developed "
          "the MVP, and established the project's structure and "
          'technical standards.',
    },
  ),
  CvExperienceItem(
    company: 'Ilog Tecnologia',
    period: 'Dez/2020 - Dez/2021',
    role: {
      'pt': 'Desenvolvedor Front End Pleno',
      'en': 'Mid-Level Front-End Developer',
    },
    description: {
      'pt': 'Evolução e manutenção de aplicações AngularJS, com '
          'desenvolvimento de novas funcionalidades, introdução do React '
          'em projeto utilizando arquitetura de Micro Frontends e '
          'desenvolvimento de interfaces personalizadas para clientes.',
      'en': 'Evolved and maintained AngularJS applications, developing new '
          'features, introducing React into a project using a Micro '
          'Frontends architecture, and building custom interfaces for '
          'clients.',
    },
  ),
  CvExperienceItem(
    company: 'Realiplasticos',
    period: 'Ago/2016 - Mar/2020',
    role: {'pt': 'Designer', 'en': 'Designer'},
    description: {
      'pt': 'Desenvolvimento e manutenção do site institucional em PHP, '
          'com foco em SEO, contribuindo para o aumento do tráfego '
          'orgânico e da visibilidade da marca.',
      'en': 'Developed and maintained the company website in PHP, with a '
          'focus on SEO, contributing to increased organic traffic and '
          'brand visibility.',
    },
  ),
  CvExperienceItem(
    company: 'Comptask Soluções Digitais',
    period: 'Jun/2014 - Jul/2016',
    role: {
      'pt': 'Desenvolvedor Full Stack Junior',
      'en': 'Junior Full Stack Developer',
    },
    description: {
      'pt': 'Atuação em diferentes projetos de sistemas e aplicações '
          'móveis, com experiência em múltiplas tecnologias e '
          'metodologias de desenvolvimento, proporcionando uma visão '
          'abrangente de arquitetura e do ciclo de vida de software. '
          'Liderança no desenvolvimento da segunda versão de uma '
          'aplicação mobile híbrida com PhoneGap, com responsabilidade '
          'por todo o ciclo do produto, desde a concepção e definição da '
          'arquitetura até a implementação e publicação nas lojas Apple e '
          'Google.',
      'en': 'Worked across different systems and mobile application '
          'projects, gaining experience with multiple technologies and '
          'development methodologies and a broad view of architecture '
          'and the software lifecycle. Led development of the second '
          'version of a PhoneGap hybrid mobile app, owning the full '
          'product cycle from conception and architecture definition '
          'through implementation and publishing on the Apple and Google '
          'stores.',
    },
  ),
  CvExperienceItem(
    company: 'Genesis Network GN1',
    period: 'Abr/2013 - Jun/2014',
    role: {
      'pt': 'Desenvolvedor Full Stack Junior',
      'en': 'Junior Full Stack Developer',
    },
    description: {
      'pt': 'Início da carreira em desenvolvimento de sistemas web, '
          'atuando na implementação e manutenção de diferentes '
          'aplicações, com experiência em liderança técnica de projeto '
          'dedicado a um cliente específico.',
      'en': 'Started my career in web systems development, working on the '
          'implementation and maintenance of different applications, with '
          'experience leading a project dedicated to a specific client.',
    },
  ),
];

const cvProjectList = [
  CvProjectItem(
    title: 'Rppay',
    tech: ['Flutter', 'MVVM', 'BLoC/Cubit', 'SOLID', 'Material 3'],
    url: 'https://github.com/ronipaschoal/rppay',
    description: {
      'pt': 'Aplicação fictícia de pagamentos usada como estudo de '
          'arquitetura feature-first, MVVM, BLoC/Cubit, SOLID e Material '
          '3. Projeto pessoal de estudo, sem uso em produção.',
      'en': 'Fictional payments app used to study feature-first '
          'architecture, MVVM, BLoC/Cubit, SOLID, and Material 3. A '
          'personal study project, not used in production.',
    },
  ),
  CvProjectItem(
    title: 'Portfólio Pessoal',
    tech: ['Flutter', 'CI/CD', 'GitHub Actions'],
    url: 'https://github.com/ronipaschoal/site_2_0',
    description: {
      'pt': 'Este site pessoal e portfólio, construído em Flutter com '
          'deploy automatizado via CI/CD no GitHub Actions. Diferente dos '
          'demais projetos pessoais, está em produção e é mantido e '
          'atualizado continuamente.',
      'en': 'This personal website and portfolio, built with Flutter and '
          'deployed automatically via GitHub Actions CI/CD. Unlike the '
          'other personal projects, it is in production and continuously '
          'maintained and updated.',
    },
  ),
];

const cvCertificationList = [
  CvCertificationItem(
    title: 'Engenharia de Prompt',
    issuer: 'Rocketseat',
    date: 'Abr/2026',
  ),
  CvCertificationItem(
    title: 'TDC São Paulo - Trilha Flutter',
    issuer: 'Globalcode',
    date: 'Set/2024',
  ),
  CvCertificationItem(
    title: 'Flutter: Desvendando Arquiteturas',
    issuer: 'Alura',
    date: 'Jul/2024',
  ),
  CvCertificationItem(
    title: 'Flutter: Teste de Unidade',
    issuer: 'Flutterando',
    date: 'Jan/2024',
  ),
  CvCertificationItem(
    title: 'TDC Innovation - Trilha Flutter',
    issuer: 'Globalcode',
    date: 'Jun/2023',
  ),
  CvCertificationItem(
    title: 'Formação Dart',
    issuer: 'Alura',
    date: 'Jan/2023',
  ),
  CvCertificationItem(
    title: 'Treinamento Flutter para Empresas (TOTVS)',
    issuer: 'FTeam',
    date: 'Dez/2022',
  ),
];

const cvEducationList = [
  CvEducationItem(
    institution: 'IFSP',
    course: 'Pós-graduação · Aplicações para Dispositivos Móveis',
    period: '2017 - 2019',
  ),
  CvEducationItem(
    institution: 'IFSP',
    course: 'Graduação · Tecnólogo em Programação de Computadores',
    period: '2014 - 2016',
  ),
  CvEducationItem(
    institution: 'IFSP',
    course: 'Técnico em Desenvolvimento de Sistemas',
    period: '2011 - 2013',
  ),
  CvEducationItem(
    institution: 'UFRJ',
    course: 'Graduação · Bacharel em Design e Artes Aplicadas',
    period: '2004 - 2009',
  ),
];
