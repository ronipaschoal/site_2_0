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
  'pt': 'Atuar como Desenvolvedor Mobile Flutter.',
  'en': 'To work as a Flutter Mobile Developer.',
};

const cvSummary = {
  'pt': 'Desenvolvedor de Software com mais de 8 anos de experiência, sendo '
      'mais de 5 anos em desenvolvimento mobile. Atuação no desenvolvimento e '
      'evolução de aplicações mobile e web, com definição de arquitetura, '
      'componentes reutilizáveis e Design Systems. Sólidos conhecimentos em '
      'Flutter, Dart, BLoC/Cubit, MVVM, APIs REST, testes automatizados e '
      'integração com recursos nativos. Experiência com SmartPOS, Offline '
      'First, CI/CD, publicação de aplicações e criação de bibliotecas '
      'compartilhadas. Vivência em desenvolvimento fullstack e uso de IA para '
      'apoiar o desenvolvimento, automação e qualidade do código.',
  'en': 'Software Developer with more than 8 years of experience, including '
      'over 5 years in mobile development. Develops and evolves mobile and '
      'web applications, defining architecture, reusable components and '
      'Design Systems. Solid knowledge of Flutter, Dart, BLoC/Cubit, MVVM, '
      'REST APIs, automated testing and native feature integration. '
      'Experienced with SmartPOS, Offline First, CI/CD, app publishing and '
      'building shared libraries. Hands-on experience with fullstack '
      'development and using AI to support development, automation and code '
      'quality.',
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
// tools under "tools" — shared by the résumé and its modern PDF; the home
// bento uses the condensed [cvHomeSkillGroups].
const cvSkillGroups = <String, List<String>>{
  'mobile': [
    'Flutter',
    'Dart',
    'Android',
    'iOS',
    'SmartPOS',
    'BLoC/Cubit',
    'Dio',
    'http',
    'get_it',
    'GoRouter',
    'Platform Channels',
    'Offline First',
    'SQLite',
    'SharedPreferences',
    'Deep Linking',
    'WebView',
  ],
  'architecture': [
    'MVVM',
    'Clean Architecture',
    'Repository Pattern',
    'SOLID',
    'Design Patterns',
    'Dependency Injection',
    'Dependency Inversion',
    'DTOs',
    'Value Objects',
    'REST',
    'Unit Testing',
    'Widget Testing',
    'Design Systems',
  ],
  'fullstack': [
    'TypeScript',
    'React',
    'Node.js',
    'Angular',
    'AngularJS',
    'Go',
  ],
  'tools': [
    'Git',
    'GitHub',
    'GitHub Actions',
    'CI/CD',
    'Fastlane',
    'Flavors',
    'Firebase',
    'Claude Code',
    'ChatGPT',
    'Cursor',
    'GitHub Copilot',
    'Prompt Engineering',
    'App Store',
    'Google Play',
    'TestFlight',
  ],
};

/// The home bento's condensed take on [cvSkillGroups] — each fact tile holds
/// a single short line, so it keeps only the headline items.
const cvHomeSkillGroups = <String, List<String>>{
  'mobile': ['Flutter', 'Dart', 'BLoC', 'Dio', 'get_it'],
  'fullstack': ['TypeScript', 'React', 'Node.js', 'Angular', 'Go'],
  'tools': ['Git', 'GitHub', 'GitHub Actions', 'CI/CD', 'Claude'],
};

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
          'Desenvolvimento de BFF em Node.js para integração do backoffice '
          'com APIs em Go. '
          'Apoio a outros membros da equipe por meio de pair programming e '
          'code review, auxiliando no desenvolvimento e na refatoração do '
          'front-end. '
          'Implementação de testes unitários com Jest, ampliando a cobertura '
          'e a confiabilidade das aplicações. Utilização de Claude Code, ChatGPT '
          'e Cursor como apoio ao desenvolvimento, refatoração de código e '
          'automação de tarefas.',
      'en': 'Evolution of the backoffice for app content management, working '
          'with React and Go. Development of a BFF in Node.js to integrate '
          'the backoffice with Go APIs. Support for other team members through '
          'pair programming and code review, helping with front-end '
          'development and refactoring. Implementation of unit tests with '
          'Jest, expanding the coverage and reliability of the applications. '
          'Use of Claude Code, ChatGPT and '
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
      'pt': 'Referência técnica na equipe mobile de 3 desenvolvedores, '
          'conduzindo a análise comparativa entre Flutter, React Native, Ionic '
          'e Xamarin que levou à adoção do Flutter como plataforma de '
          'desenvolvimento mobile. Definição da arquitetura, das bibliotecas e '
          'dos padrões técnicos, incluindo decisões alinhadas em reuniões com '
          'outras equipes. Apoio ao time por meio de pair programming e code '
          'review, além de participação no refinamento e nas estimativas junto '
          'ao PO. '
          'Desenvolvimento e evolução dos aplicativos Minha Comanda Eletrônica '
          'e Minha Governança Hoteleira para Android, iOS e SmartPOS, '
          'utilizando MVVM, BLoC/Cubit, Repository Pattern e APIs REST com '
          'Dio. '
          'Implementação de estratégias Offline First, utilizando SQLite e '
          'SharedPreferences para persistência local, gerenciamento dos '
          'pedidos e sincronização posterior com os serviços remotos. '
          'Desenvolvimento de integrações com APIs REST utilizando Dio e '
          'Dartz, com aplicação de Either para representação explícita de '
          'sucesso e falha e princípios de imutabilidade. '
          'Criação de biblioteca compartilhada de componentes baseada no '
          'Design System corporativo, promovendo padronização e reutilização '
          'entre aplicações. '
          'Desenvolvimento de biblioteca Flutter para configuração e '
          'integração com diferentes modelos de SmartPOS, utilizando Platform '
          'Channels/MethodChannel para comunicação com a camada nativa Android '
          'e abstração das particularidades dos dispositivos. '
          'Integração das aplicações com diferentes provedores e adquirentes '
          'de pagamento, incluindo Cielo, Adyen, Getnet, PagSeguro e Rede. '
          'Utilização de flavors nos aplicativos para gerenciamento de '
          'diferentes configurações e ambientes, incluindo configurações '
          'específicas das integrações de pagamento. '
          'Configuração e manutenção de pipelines de CI/CD, com otimizações '
          'voltadas à redução do tempo de execução. '
          'Configuração de bibliotecas privadas para execução de testes '
          'unitários e widget tests. '
          'Publicação e distribuição das aplicações para Android, iOS e '
          'diferentes modelos de SmartPOS.',
      'en': 'Technical reference on a 3-developer mobile team, leading the '
          'comparative analysis of Flutter, React Native, Ionic and Xamarin '
          'that led to adopting Flutter as the mobile development platform. '
          'Defined the architecture, libraries and technical standards, '
          'including decisions aligned in meetings with other teams. Supported '
          'the team through pair programming and code review, and took part '
          'in refinement and estimation with the PO. '
          'Developed and evolved the Minha Comanda Eletrônica and Minha '
          'Governança Hoteleira apps for Android, iOS and SmartPOS, using '
          'MVVM, BLoC/Cubit, the Repository Pattern and REST APIs with Dio. '
          'Implemented Offline First strategies, using SQLite and '
          'SharedPreferences for local persistence, order management and '
          'later synchronization with the remote services. '
          'Built REST API integrations with Dio and Dartz, applying Either to '
          'represent success and failure explicitly, along with immutability '
          'principles. '
          'Built a shared component library based on the corporate Design '
          'System, promoting standardization and reuse across applications. '
          'Developed a Flutter library for configuring and integrating with '
          'different SmartPOS models, using Platform Channels/MethodChannel '
          'to communicate with the native Android layer and abstract away '
          'device-specific differences. '
          'Integrated the apps with different payment providers and '
          'acquirers, including Cielo, Adyen, Getnet, PagSeguro and Rede. '
          'Used flavors in the apps to manage different configurations and '
          'environments, including payment-integration-specific settings. '
          'Configured and maintained CI/CD pipelines, with optimizations '
          'aimed at reducing execution time. '
          'Set up private libraries for running unit and widget tests. '
          'Published and distributed the applications for Android, iOS and '
          'different SmartPOS models.',
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
          'ampliação da cobertura de testes automatizados. Atuação em pair '
          'programming com a equipe. Otimização de '
          'pipelines de CI/CD no Azure DevOps, reduzindo o tempo de execução '
          'dos processos. Utilização do GitHub Copilot como apoio ao '
          'desenvolvimento, refatoração e manutenção de código.',
      'en': 'Evolved an Angular application for the hospitality industry, '
          'developing features, fixing bugs, delivering continuous '
          'improvements, and expanding automated test coverage. Worked in pair '
          'programming with the team. Optimized '
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
      'pt': 'Condução autônoma do desenvolvimento da aplicação mobile de '
          'gestão financeira e fiscal para MEIs, desde a definição da '
          'arquitetura e desenvolvimento do MVP até a evolução para a segunda '
          'versão, utilizando Flutter/Dart e com publicação para Android e '
          'iOS. '
          'Implementação de funcionalidades utilizando BLoC/Cubit para '
          'gerenciamento de estado, com separação entre UI, estado e serviços '
          'responsáveis pelas integrações com APIs REST. '
          'Desenvolvimento de integrações com APIs REST, utilizando http, além '
          'de aplicação de padrões como inversão de dependência, DTOs, Value '
          'Objects e componentes compartilhados. '
          'Desenvolvimento de navegação com GoRouter e deep links, além de '
          'configuração de ambientes DEV, STG e PROD utilizando '
          '--dart-define. '
          'Implementação de recursos com Firebase, incluindo Crashlytics, '
          'Remote Config, Analytics e Firebase Cloud Messaging. '
          'Configuração e manutenção de pipelines de CI/CD com GitHub Actions '
          'e Fastlane, automatizando builds e a publicação da aplicação iOS no '
          'TestFlight.',
      'en': 'Independently led the development of the mobile financial and '
          'tax management app for MEIs (Brazilian micro-entrepreneurs), from '
          'defining the architecture and building the MVP through its '
          'evolution into the second version, using Flutter/Dart and '
          'publishing for Android and iOS. '
          'Implemented features using BLoC/Cubit for state management, '
          'separating UI, state and the services responsible for REST API '
          'integrations. '
          'Built REST API integrations using http, applying patterns such as '
          'dependency inversion, DTOs, Value Objects and shared components. '
          'Built navigation with GoRouter and deep links, and configured DEV, '
          'STG and PROD environments using --dart-define. '
          'Implemented Firebase features, including Crashlytics, Remote '
          'Config, Analytics and Firebase Cloud Messaging. '
          'Configured and maintained CI/CD pipelines with GitHub Actions and '
          'Fastlane, automating builds and the publishing of the iOS app to '
          'TestFlight.',
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
          'Desenvolvimento de interfaces com React e TypeScript, além de APIs '
          'e funcionalidades back-end com Node.js, utilizando HTML5, CSS3 e '
          'Git.',
      'en': 'Independently led the development of the React application, from '
          'defining the architecture and building the MVP to establishing '
          "the project's structure and technical standards. Built interfaces "
          'with React and TypeScript, as well as back-end APIs and features '
          'with Node.js, using HTML5, CSS3 and Git.',
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
          'e distribuição de aplicações nas lojas Google Play e App Store. '
          'Participação no desenvolvimento de aplicação desktop em C# para '
          'monitoramento pulmonar por tomografia por impedância elétrica '
          '(EIT), integrada via USB a uma cinta torácica, com captura das '
          'leituras, exibição em tempo real das áreas ventiladas do pulmão e '
          'histórico de leituras, atuando na implementação de testes '
          'unitários e de novos parâmetros na tela utilizando polimorfismo.',
      'en': 'Developed web systems and hybrid mobile applications with '
          'PhoneGap, AngularJS, SQLite, PHP and MySQL. Worked independently on '
          'mobile projects, from implementation to publishing for Android and '
          'iOS. Developed the second version of a mobile app with PhoneGap and '
          'AngularJS, including defining the architecture and evolving the '
          'solution. Developed PHP APIs with CodeIgniter for integration with '
          'the mobile app. Published and distributed apps on Google Play and '
          'the App Store. Took part in developing a C# desktop application for '
          'lung monitoring with Electrical Impedance Tomography (EIT), '
          'connected over USB to a chest belt, capturing readings, showing the '
          'ventilated areas of the lungs in real time and keeping a history of '
          'readings, including writing unit tests and adding new on-screen '
          'parameters using polymorphism.',
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
      'pt': 'App fictício de pagamentos (estudo de arquitetura Flutter): '
          'Feature-First, MVVM, BLoC/Cubit, Repository Pattern, '
          'Injeção de Dependência e SOLID. Navegação dinâmica via API mock, '
          'WebView com pacote próprio, testes unitários e de widget, CI/CD '
          '(GitHub Actions) e IA (Claude Code, Gemini).',
      'en': 'Fictional payments app (Flutter architecture study): layered '
          'Feature-First, MVVM, BLoC/Cubit, Repository Pattern, Dependency '
          'Injection and SOLID. Dynamic navigation from a mock '
          'API, WebView via an in-house package, unit and widget tests, '
          'GitHub Actions CI/CD and AI (Claude Code, Gemini).',
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
      'pt': 'Site pessoal e portfólio em produção com Flutter Web e Dart: '
          'BLoC/Cubit, go_router, i18n (PT/EN), tema claro/escuro e currículo '
          'em PDF. Acessibilidade WCAG (leitores de tela, teclado, contraste '
          'AA) no pacote próprio a11y_kit, com testes de widget e '
          'acessibilidade e CI/CD no GitHub Actions.',
      'en': 'Personal site and portfolio in production with Flutter Web and '
          'Dart: BLoC/Cubit, go_router, i18n (PT/EN), light/dark theme and PDF '
          'résumé. WCAG accessibility (screen readers, keyboard, AA contrast) '
          'in the in-house a11y_kit package, with widget and accessibility '
          'tests and GitHub Actions CI/CD.',
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
    period: 'Previsão de conclusão: 10/2028',
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
