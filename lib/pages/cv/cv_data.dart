import 'package:ronip/models/cv_item_model.dart';

/// Birth year, used to compute the age shown in the résumé header. Only the
/// year is tracked (not the full birth date), so the age simply follows the
/// current calendar year rather than the exact birthday.
const cvBirthYear = 1985;

/// The single contact email shown across the site (résumé and the home
/// page's Contact section) — kept in one place so the two never drift apart.
const contactEmail = 'ronipaschoal@gmail.com';

/// Phone number, printed only on the classic PDF résumé (its layout asks
/// for one); the on-screen résumé and the modern PDF don't show it.
const cvPhone = CvContactItem(
  type: CvContactType.phone,
  text: '(11) 98186-3256',
  url: 'tel:+5511981863256',
);

/// The résumé's content, shared by the on-screen [CvContentWidget] and the
/// PDF export (`CvPdfBuilder`) so both stay in sync from one source.
const cvObjective = {
  'pt': 'Atuar como Desenvolvedor Mobile Flutter, contribuindo no '
      'desenvolvimento e evolução de aplicações Android e iOS, utilizando '
      'Dart, arquitetura de software, gerenciamento de estado, APIs REST, '
      'testes automatizados e boas práticas de desenvolvimento.',
  'en': 'To work as a Flutter Mobile Developer, contributing to the '
      'development and evolution of Android and iOS applications, using '
      'Dart, software architecture, state management, REST APIs, automated '
      'testing and development best practices.',
};

const cvSummary = {
  'pt': 'Desenvolvedor de Software com mais de 8 anos de experiência, sendo '
      'mais de 5 anos em desenvolvimento mobile. Atuação no desenvolvimento e '
      'evolução de aplicações mobile e web, com definição de arquitetura, '
      'componentes reutilizáveis e Design Systems. Sólidos conhecimentos em '
      'Flutter, Dart, BLoC/Cubit, MVVM, APIs REST e testes automatizados. '
      'Vivência em desenvolvimento fullstack, publicação de aplicações e '
      'integração com recursos nativos. Experiência na criação de bibliotecas '
      'compartilhadas e no uso de IA para apoiar o desenvolvimento e a '
      'qualidade do código.',
  'en': 'Software Developer with more than 8 years of experience, including '
      'over 5 years in mobile development. Develops and evolves mobile and '
      'web applications, defining architecture, reusable components and '
      'Design Systems. Solid knowledge of Flutter, Dart, BLoC/Cubit, MVVM, '
      'REST APIs and automated testing. Hands-on experience with fullstack '
      'development, app publishing and native feature integration. '
      'Experienced in building shared libraries and using AI to support '
      'development and code quality.',
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

/// The classic PDF's "Technical skills" list — broader and grouped
/// differently from [cvSkillGroups], which feeds the on-screen résumé, the
/// modern PDF and the home bento.
const cvClassicSkillGroups = [
  (
    label: {'pt': 'Mobile', 'en': 'Mobile'},
    items: {
      'pt': 'Flutter, Dart, Android, iOS, State Management (BLoC/Cubit), '
          'MVVM, Repository Pattern, Platform Channels, Offline First, '
          'SQLite, SharedPreferences, Deep Linking, WebView.',
      'en': 'Flutter, Dart, Android, iOS, State Management (BLoC/Cubit), '
          'MVVM, Repository Pattern, Platform Channels, Offline First, '
          'SQLite, SharedPreferences, Deep Linking, WebView.',
    },
  ),
  (
    label: {'pt': 'Arquitetura e qualidade', 'en': 'Architecture and quality'},
    items: {
      'pt': 'Software Architecture, SOLID, Design Patterns, Dependency '
          'Injection (GetIt), Unit Testing, Widget Testing, Design Systems, '
          'componentes reutilizáveis.',
      'en': 'Software Architecture, SOLID, Design Patterns, Dependency '
          'Injection (GetIt), Unit Testing, Widget Testing, Design Systems, '
          'reusable components.',
    },
  ),
  (
    label: {'pt': 'APIs e desenvolvimento', 'en': 'APIs and development'},
    items: {
      'pt': 'REST APIs, Dio, Git, CI/CD, GitHub Actions.',
      'en': 'REST APIs, Dio, Git, CI/CD, GitHub Actions.',
    },
  ),
  (
    label: {'pt': 'Web', 'en': 'Web'},
    items: {
      'pt': 'React, TypeScript, Angular, AngularJS, Go.',
      'en': 'React, TypeScript, Angular, AngularJS, Go.',
    },
  ),
  (
    label: {
      'pt': 'IA aplicada ao desenvolvimento',
      'en': 'AI applied to development',
    },
    items: {
      'pt': 'Claude Code, ChatGPT, Cursor, GitHub Copilot, AI-assisted '
          'Development, Prompt Engineering.',
      'en': 'Claude Code, ChatGPT, Cursor, GitHub Copilot, AI-assisted '
          'Development, Prompt Engineering.',
    },
  ),
  (
    label: {'pt': 'Publicação', 'en': 'Publishing'},
    items: {
      'pt': 'App Store, Google Play.',
      'en': 'App Store, Google Play.',
    },
  ),
];

const cvLanguageList = [
  CvLanguageItem(
    language: {'pt': 'Inglês', 'en': 'English'},
    level: {'pt': 'Nível intermediário', 'en': 'Intermediate proficiency'},
    usage: {
      'pt': 'Leitura, escrita e participação passiva em reuniões',
      'en': 'Reading, writing and passive participation in meetings',
    },
  ),
];

/// A one-line description of the company, keyed by
/// [CvExperienceItem.company] — shown in italics under the company heading
/// on screen and in both PDFs, for employers a recruiter may not know.
const cvCompanyDescriptions = {
  'Setfin': {
    'pt': 'Fintech especializada em soluções de gestão financeira para '
        'microempreendedores.',
    'en': 'Fintech specialized in financial management solutions for '
        'micro-entrepreneurs.',
  },
};

/// Who actually hired for a company's roles when it was an outsourced
/// contract, keyed by [CvExperienceItem.company] — shown in italics before
/// the role on screen and in both PDFs.
const cvCompanyContractors = {
  'TOTVS': {
    'pt': 'Contratado pela TO-Brasil',
    'en': 'Hired through TO-Brasil',
  },
};

const cvExperienceList = [
  CvExperienceItem(
    company: 'Mercado Pago',
    period: 'Jul/2025 - Jun/2026',
    role: {
      'pt': 'Engenheiro de Software',
      'en': 'Software Engineer',
    },
    description: {
      'pt': 'Evolução do backoffice para gestão de conteúdo do aplicativo, '
          'com atuação em React e Go. '
          'Desenvolvimento de testes unitários para garantir a qualidade e a '
          'confiabilidade das aplicações. Utilização de Claude Code, ChatGPT '
          'e Cursor como apoio ao desenvolvimento, refatoração de código e '
          'automação de tarefas.',
      'en': 'Evolution of the backoffice for app content management, working '
          'with React and Go. Development of unit tests to ensure the quality and '
          'reliability of the applications. Use of Claude Code, ChatGPT and '
          'Cursor to support development, code refactoring and task '
          'automation.',
    },
  ),
  CvExperienceItem(
    company: 'TOTVS',
    period: 'Mar/2022 - Abr/2025',
    role: {
      'pt': 'Desenvolvedor Mobile Sênior - Flutter',
      'en': 'Senior Mobile Developer - Flutter',
    },
    description: {
      'pt': 'Definição e adoção do Flutter como plataforma de desenvolvimento '
          'mobile, contribuindo na estruturação da equipe e na definição de '
          'arquitetura e padrões técnicos. Desenvolvimento e evolução dos '
          'aplicativos Minha Comanda Eletrônica e Minha Governança Hoteleira, '
          'utilizando MVVM, BLoC/Cubit, Repository Pattern e APIs REST com '
          'Dio. Implementação de estratégias Offline First, utilizando SQLite '
          'e SharedPreferences para persistência local. Criação de biblioteca '
          'de componentes baseada no Design System corporativo, promovendo '
          'padronização e reutilização entre aplicações. Desenvolvimento de '
          'biblioteca para configuração e integração com dispositivos Smart '
          'POS, utilizando Platform Channels. Configuração e manutenção de '
          'pipelines de CI/CD, com otimizações para redução do tempo de '
          'execução. Configuração de bibliotecas privadas para execução de '
          'testes unitários e widget tests. Publicação e distribuição de '
          'aplicações para Android, iOS e diferentes modelos de Smart POS.',
      'en': 'Defined and adopted Flutter as the mobile development platform, '
          'contributing to structuring the team and defining the architecture '
          'and technical standards. Developed and evolved the Minha Comanda '
          'Eletrônica and Minha Governança Hoteleira apps, using MVVM, '
          'BLoC/Cubit, the Repository Pattern and REST APIs with Dio. '
          'Implemented Offline First strategies, using SQLite and '
          'SharedPreferences for local persistence. Built a component library '
          'based on the corporate Design System, promoting standardization and '
          'reuse across applications. Developed a library for configuring and '
          'integrating with Smart POS devices, using Platform Channels. '
          'Configured and maintained CI/CD pipelines, with optimizations to '
          'reduce execution time. Set up private libraries for running unit '
          'and widget tests. Published and distributed applications for '
          'Android, iOS and various Smart POS models.',
    },
  ),
  CvExperienceItem(
    company: 'TOTVS',
    period: 'Dez/2021 - Fev/2022',
    role: {
      'pt': 'Desenvolvedor Front-End Pleno',
      'en': 'Mid-Level Front-End Developer',
    },
    description: {
      'pt': 'Evolução de aplicação Angular para hotelaria, com desenvolvimento '
          'de funcionalidades, correção de bugs, melhorias contínuas e '
          'ampliação da cobertura de testes automatizados. Otimização de '
          'pipelines de CI/CD no Azure DevOps, reduzindo o tempo de execução '
          'dos processos. Utilização do GitHub Copilot como apoio ao '
          'desenvolvimento, refatoração e manutenção de código.',
      'en': 'Evolved an Angular application for the hospitality industry, '
          'developing features, fixing bugs, delivering continuous '
          'improvements, and expanding automated test coverage. Optimized '
          'CI/CD pipelines on Azure DevOps, reducing process execution time. '
          'Used GitHub Copilot to support development, refactoring and code '
          'maintenance.',
    },
  ),
  CvExperienceItem(
    company: 'Setfin',
    period: 'Set/2022 - Out/2023',
    role: {
      'pt': 'Desenvolvedor de Software - Flutter | Freelance',
      'en': 'Software Developer - Flutter | Freelance',
    },
    description: {
      'pt': 'Condução autônoma do desenvolvimento da aplicação Flutter, desde '
          'a definição da arquitetura e desenvolvimento do MVP até a segunda '
          'versão, utilizando MVVM, BLoC/Cubit e GetIt. Desenvolvimento de '
          'integrações com APIs REST via Dio, utilizando Git para controle de '
          'versão, e publicação da aplicação para Android e iOS.',
      'en': 'Independently led the development of the Flutter application, '
          'from defining the architecture and building the MVP through the '
          'second version, using MVVM, BLoC/Cubit and GetIt. Developed REST '
          'API integrations via Dio, using Git for version control, and '
          'published the app for Android and iOS.',
    },
  ),
  CvExperienceItem(
    company: 'Setfin',
    period: 'Set/2021 - Ago/2022',
    role: {
      'pt': 'Desenvolvedor Front-End - React | Freelance',
      'en': 'Front-End Developer - React | Freelance',
    },
    description: {
      'pt': 'Condução autônoma do desenvolvimento da aplicação React, desde a '
          'definição da arquitetura e desenvolvimento do MVP até o '
          'estabelecimento da estrutura e dos padrões técnicos do projeto. '
          'Desenvolvimento de interfaces utilizando React, TypeScript, HTML5 '
          'e CSS3, com versionamento via Git.',
      'en': 'Independently led the development of the React application, from '
          'defining the architecture and building the MVP to establishing '
          "the project's structure and technical standards. Built interfaces "
          'using React, TypeScript, HTML5 and CSS3, with version control via '
          'Git.',
    },
  ),
  CvExperienceItem(
    company: 'Ilog Tecnologia',
    period: 'Dez/2020 - Dez/2021',
    role: {
      'pt': 'Desenvolvedor Front End',
      'en': 'Front-End Developer',
    },
    description: {
      'pt': 'Evolução e manutenção de aplicações AngularJS, com '
          'desenvolvimento de novas funcionalidades e melhorias contínuas. '
          'Introdução do React com TypeScript em projeto utilizando arquitetura de Micro '
          'Frontends, contribuindo para a evolução da arquitetura da '
          'aplicação. Desenvolvimento de interfaces personalizadas de acordo '
          'com as necessidades de diferentes clientes.',
      'en': 'Evolved and maintained AngularJS applications, developing new '
          'features and delivering continuous improvements. Introduced React '
          'into a project using a Micro Frontends architecture, contributing '
          "to the evolution of the application's architecture. Built custom "
          'interfaces tailored to the needs of different clients.',
    },
  ),
  CvExperienceItem(
    company: 'Realiplasticos',
    period: 'Ago/2016 - Mar/2020',
    role: {'pt': 'Designer', 'en': 'Designer'},
    description: {
      'pt': 'Desenvolvimento e manutenção do site institucional em PHP, '
          'com foco em SEO e otimização da visibilidade e do tráfego '
          'orgânico.',
      'en': 'Developed and maintained the company website in PHP, with a '
          'focus on SEO and optimizing visibility and organic traffic.',
    },
  ),
  CvExperienceItem(
    company: 'Comptask Soluções Digitais',
    period: 'Jun/2014 - Jul/2016',
    role: {
      'pt': 'Desenvolvedor Full Stack',
      'en': 'Full Stack Developer',
    },
    description: {
      'pt': 'Desenvolvimento de sistemas web e aplicações mobile híbridas com '
          'PhoneGap, AngularJS, SQLite, PHP e MySQL. Atuação autônoma no '
          'desenvolvimento de projetos mobile, desde a implementação até a '
          'publicação para Android e iOS. Desenvolvimento da segunda versão de '
          'aplicação mobile com PhoneGap e AngularJS, incluindo definição da '
          'arquitetura e evolução da solução. Desenvolvimento de APIs em PHP '
          'com CodeIgniter para integração com a aplicação mobile. Publicação '
          'e distribuição de aplicações nas lojas Google Play e App Store.',
      'en': 'Developed web systems and hybrid mobile applications with '
          'PhoneGap, AngularJS, SQLite, PHP and MySQL. Worked independently on '
          'mobile projects, from implementation to publishing for Android and '
          'iOS. Developed the second version of a mobile app with PhoneGap and '
          'AngularJS, including defining the architecture and evolving the '
          'solution. Developed PHP APIs with CodeIgniter for integration with '
          'the mobile app. Published and distributed apps on Google Play and '
          'the App Store.',
    },
  ),
  CvExperienceItem(
    company: 'Genesis Network GN1',
    period: 'Abr/2013 - Jun/2014',
    role: {
      'pt': 'Desenvolvedor Full Stack',
      'en': 'Full Stack Developer',
    },
    description: {
      'pt': 'Desenvolvimento e manutenção de dois sistemas web utilizando ASP '
          'e JavaScript. Liderança técnica na conclusão e entrega de projeto '
          'ao cliente.',
      'en': 'Developed and maintained two web systems using ASP and '
          'JavaScript. Provided technical leadership in completing and '
          'delivering a project to the client.',
    },
  ),
];

const cvProjectList = [
  CvProjectItem(
    title: 'Rppay',
    tech: [
      'Flutter',
      'Feature-First',
      'MVVM',
      'BLoC/Cubit',
      'Repository Pattern',
      'SOLID',
      'CI/CD',
    ],
    url: 'https://github.com/ronipaschoal/rppay',
    description: {
      'pt': 'Aplicação fictícia de pagamentos desenvolvida como estudo de '
          'arquitetura em Flutter, com organização Feature-First em camadas '
          '(presentation, domain e data), MVVM, BLoC/Cubit, Repository '
          'Pattern, Injeção de Dependência, princípios SOLID e Material 3. '
          'Navegação dinâmica a partir de API simulada, com integração de '
          'WebView por meio de pacote próprio. Testes unitários (bloc_test) e '
          'de widget, executados no pipeline de CI/CD do GitHub Actions '
          'com deploy web automatizado. Desenvolvimento assistido por IA com '
          'Claude Code e Gemini. Projeto pessoal de estudo, sem uso em '
          'produção.',
      'en': 'Fictional payments app built as a Flutter architecture study, '
          'with a Feature-First organization in layers (presentation, domain '
          'and data), MVVM, BLoC/Cubit, Repository Pattern, Dependency '
          'Injection, SOLID principles and Material 3. Dynamic navigation '
          'driven by a simulated API, with WebView integration through an '
          'in-house package. Unit (bloc_test) and widget tests, run in a '
          'GitHub Actions CI/CD pipeline with automated web deployment. '
          'AI-assisted development with Claude Code and Gemini. A personal '
          'study project, not used in production.',
    },
  ),
  CvProjectItem(
    title: 'Portfólio Pessoal',
    tech: [
      'Flutter Web',
      'BLoC/Cubit',
      'go_router',
      'i18n',
      'Accessibility',
      'CI/CD',
    ],
    url: 'https://github.com/ronipaschoal/site_2_0',
    description: {
      'pt': 'Site pessoal e portfólio em produção, desenvolvido com Flutter '
          'Web e Dart, utilizando BLoC/Cubit, go_router, internacionalização '
          '(PT/EN), tema claro/escuro e geração de currículo em PDF. '
          'Acessibilidade baseada nas diretrizes WCAG, com semântica para '
          'leitores de tela, navegação por teclado e contraste AA, extraída '
          'para o pacote próprio a11y_kit. Testes de widget e de '
          'acessibilidade, com deploy automatizado via CI/CD no GitHub '
          'Actions.',
      'en': 'Personal website and portfolio in production, built with '
          'Flutter Web and Dart, using BLoC/Cubit, go_router, '
          'internationalization (PT/EN), light/dark theme and PDF résumé '
          'generation. Accessibility based on WCAG guidelines, with screen '
          'reader semantics, keyboard navigation and AA contrast, extracted '
          'into the in-house a11y_kit package. Widget and accessibility '
          'tests, with automated deployment via GitHub Actions CI/CD.',
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
    title: 'TDC São Paulo: Trilha Flutter',
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
    title: 'TDC Innovation: Trilha Flutter',
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
    institution: 'USP',
    course: 'MBA em Engenharia de Software',
    period: 'Previsão de conclusão: Out/2026',
  ),
  CvEducationItem(
    institution: 'IFSP',
    course:
        'Especialização em Desenvolvimento de Aplicações para Dispositivos Móveis',
    period: '2019',
  ),
  CvEducationItem(
    institution: 'IFSP',
    course: 'Tecnologia em Sistemas para Internet',
    period: '2016',
  ),
  CvEducationItem(
    institution: 'IFSP',
    course: 'Técnico em Desenvolvimento de Sistemas',
    period: '2013',
  ),
  CvEducationItem(
    institution: 'UFRJ',
    course: 'Bacharel em Design e Artes Aplicadas',
    period: '2009',
  ),
];
