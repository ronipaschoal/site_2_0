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

/// The technology the résumé is pitched at: it names the role, the
/// objective and the header's stack line. `/cv?focus=híbrido` swaps it for
/// another one (see [cvFocusFrom]); the rest of the content is unchanged.
const cvDefaultFocus = 'Flutter';

/// The focus from the `focus` query parameter, or [cvDefaultFocus] when
/// it's missing or blank. Kept as typed; titles go through [cvFocusTitle].
String cvFocusFrom(String? value) {
  final focus = value?.trim() ?? '';
  return focus.isEmpty ? cvDefaultFocus : focus;
}

/// [focus] capitalized, for the role, objective and stack line.
String cvFocusTitle(String focus) =>
    focus[0].toUpperCase() + focus.substring(1);

/// The résumé's role title, for the modern PDF and `tool/seo_content.dart`,
/// which have no BuildContext to read AppLocalizations from. Same copy as
/// `cvRole` in the ARB files, which the on-screen résumé uses; keep them in
/// sync.
String cvRoleFor(String languageCode, {String focus = cvDefaultFocus}) {
  focus = cvFocusTitle(focus);
  return switch (languageCode) {
    'en' => '$focus Mobile Software Developer',
    _ => 'Desenvolvedor de Software Mobile $focus',
  };
}

/// The résumé's content, shared by the on-screen [CvContentWidget] and the
/// PDF export (`CvPdfBuilder`) so both stay in sync from one source.
String cvObjectiveFor(String languageCode, {String focus = cvDefaultFocus}) {
  focus = cvFocusTitle(focus);
  return switch (languageCode) {
    'en' => 'To work as a $focus Mobile Developer.',
    _ => 'Atuar como Desenvolvedor Mobile $focus.',
  };
}

/// The header's stack line. Dart only goes with Flutter, so another focus
/// takes the place of both.
String cvStackLineFor({String focus = cvDefaultFocus}) {
  final stack =
      focus == cvDefaultFocus ? 'Flutter · Dart' : cvFocusTitle(focus);
  return '$stack · Android · iOS';
}

/// The résumé's summary. It doesn't follow the focus: the mobile experience
/// reads as hybrid whatever the résumé is pitched at.
String cvSummaryFor(String languageCode) {
  return switch (languageCode) {
    'en' => "I've been developing software for over 8 years, more than 5 "
        'of them dedicated to hybrid mobile development, with experience '
        'in Flutter, Dart and React Native. I build Android, iOS and '
        'SmartPOS applications, from MVP to test distribution via Google '
        'Play and TestFlight and publishing to the stores. I work with '
        'MVVM, BLoC/Cubit, REST APIs, native features and Offline First '
        'strategies. At TOTVS, I was invited '
        'to help structure a mobile team, contributing to technology '
        'decisions, architectures and development standards. I built '
        'shared Flutter libraries for the Design System and for '
        'integrating with payment terminals and acquirers. I also have '
        'experience with automated testing, CI/CD and fullstack '
        'development with React, TypeScript, Angular, Node.js and Go. I '
        'use AI, especially Claude Code, to speed up development and '
        'improve the quality of deliveries.',
    _ => 'Desenvolvo software há mais de 8 anos, sendo mais de 5 '
        'dedicados ao desenvolvimento mobile híbrido, com experiência em '
        'Flutter, Dart e React Native. Atuo no desenvolvimento de '
        'aplicações Android, iOS e SmartPOS, do MVP à distribuição para '
        'testes via Google Play e TestFlight e publicação nas lojas. '
        'Trabalho com MVVM, BLoC/Cubit, APIs REST, recursos nativos e '
        'estratégias Offline First. Na '
        'TOTVS, fui convidado a participar da estruturação de uma equipe '
        'mobile, contribuindo para decisões tecnológicas, arquiteturas e '
        'padrões de desenvolvimento. Desenvolvi em Flutter bibliotecas '
        'compartilhadas de Design System e integração com máquinas de '
        'pagamento e adquirentes. Também tenho experiência com testes '
        'automatizados, CI/CD e desenvolvimento fullstack com React, '
        'TypeScript, Angular, Node.js e Go. Utilizo IA, especialmente '
        'Claude Code, para acelerar o desenvolvimento e melhorar a '
        'qualidade das entregas.',
  };
}

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
      'pt': 'Evoluí o backoffice de gestão de conteúdo do app (shortcuts da '
          'home, menu e tab bar), usado por times internos da Argentina, do '
          'Brasil e do México, validando as configurações nos apps de teste '
          'Android e iOS. Desenvolvi o CRUD de banners de campanhas com live '
          'preview, utilizando React, TypeScript, Formik e Yup. Construí '
          'interfaces com internacionalização (i18n), utilizando os Design '
          'Systems internos Andes e AndesX, SCSS e o framework interno Nordic. '
          'Integrei o front-end às APIs em Go via REST, por meio de um BFF em '
          'Node.js (Nordic, baseado em Express). Criei endpoints em Go com '
          'arquitetura hexagonal, MySQL e testes unitários. Implementei testes '
          'unitários com Jest, elevando a cobertura do front-end de 0 para '
          'mais de 80%. Entreguei via CI/CD com GitHub e Fury e monitorei as '
          'aplicações com Datadog, Kibana e Grafana. Apoiei o time no '
          'desenvolvimento e na refatoração do front-end com pair programming '
          'e code review, em Kanban com Jira. Acelerei a geração de testes, a '
          'investigação de bugs e a criação de funcionalidades com Claude '
          'Code, ChatGPT e Cursor. Configurei o CLAUDE.md do front-end e criei '
          'um plugin para Claude Code que automatiza a atualização da URL dos '
          'shortcuts.',
      'en': "Evolved the app's content management backoffice (home shortcuts, "
          'menu and tab bar), used by internal teams in Argentina, Brazil and '
          'Mexico, validating the settings in the Android and iOS test apps. '
          'Built the campaign banner CRUD with live preview, using React, '
          'TypeScript, Formik and Yup. Built interfaces with '
          'internationalization (i18n), using the internal Andes and AndesX '
          'Design Systems, SCSS and the internal Nordic framework. Integrated '
          'the front end with the Go APIs over REST through a Node.js BFF '
          '(Nordic, based on Express). Created Go endpoints with hexagonal '
          'architecture, MySQL and unit tests. Wrote unit tests with Jest, '
          'raising front-end coverage from 0 to over 80%. Shipped through '
          'CI/CD with GitHub and Fury and monitored the applications with '
          'Datadog, Kibana and Grafana. Supported the team in front-end '
          'development and refactoring through pair programming and code '
          'review, using Kanban with Jira. Sped up test generation, bug '
          'investigation and feature development with Claude Code, ChatGPT and '
          "Cursor. Set up the front end's CLAUDE.md and created a Claude Code "
          'plugin that automates updating the shortcuts URL.',
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
      'pt': 'Atuei como referência técnica de uma equipe mobile de 3 '
          'desenvolvedores. Conduzi a avaliação comparativa entre Flutter, '
          'React Native, Ionic e Xamarin, resultando na adoção do Flutter. '
          'Defini a arquitetura, as bibliotecas e os padrões técnicos da '
          'plataforma mobile, alinhados com outras equipes da organização. '
          'Desenvolvi os aplicativos Minha Comanda Eletrônica e Minha '
          'Governança Hoteleira para Android, iOS e SmartPOS, utilizando '
          'Flutter, Dart, BLoC/Cubit, arquitetura em camadas, Repository '
          'Pattern e injeção de dependências com GetIt. Implementei '
          'funcionalidades Offline First com detecção de conectividade e '
          'sincronização posterior de pedidos, utilizando Hive, SQLite e '
          'SharedPreferences. Integrei APIs REST com Dio e comunicação em '
          'tempo real via SignalR para notificações de pagamento. Desenvolvi '
          'uma biblioteca compartilhada de componentes e tokens do Design '
          'System corporativo, reutilizada entre as aplicações. Criei uma '
          'biblioteca Flutter de integração com diferentes modelos de '
          'SmartPOS, abstraindo particularidades de hardware via Platform '
          'Channels e MethodChannel. Integrei os adquirentes Cielo, Adyen, '
          'Getnet, PagSeguro, Rede e SafraPay, com Pix, TEF, leitura NFC e '
          'impressão de comprovantes e relatórios. Implementei monitoramento '
          'com Datadog e internacionalização em português, inglês e espanhol. '
          'Configurei ambientes e builds por adquirente via flavors e '
          'dart-define. Otimizei o CI/CD no Azure DevOps com análise estática, '
          'lint customizado e Git Hooks. Publiquei e mantive os aplicativos na '
          'Google Play, na App Store e em diferentes modelos de SmartPOS.',
      'en': 'Acted as technical reference for a 3-developer mobile team. Led a '
          'comparative evaluation of Flutter, React Native, Ionic and Xamarin, '
          'resulting in the adoption of Flutter. Defined the architecture, '
          'libraries and technical standards of the mobile platform, aligned '
          'with other teams across the organization. Built the Minha Comanda '
          'Eletrônica and Minha Governança Hoteleira apps for Android, iOS and '
          'SmartPOS, using Flutter, Dart, BLoC/Cubit, layered architecture, '
          'the Repository Pattern and dependency injection with GetIt. '
          'Implemented Offline First features with connectivity detection and '
          'later order synchronization, using Hive, SQLite and '
          'SharedPreferences. Integrated REST APIs with Dio and real-time '
          'communication via SignalR for payment notifications. Built a shared '
          'library of components and tokens for the corporate Design System, '
          'reused across the applications. Created a Flutter library to '
          'integrate with different SmartPOS models, abstracting away hardware '
          'specifics via Platform Channels and MethodChannel. Integrated the '
          'Cielo, Adyen, Getnet, PagSeguro, Rede and SafraPay acquirers, with '
          'Pix, TEF, NFC reading and printing of receipts and reports. '
          'Implemented monitoring with Datadog and internationalization in '
          'Portuguese, English and Spanish. Configured per-acquirer '
          'environments and builds via flavors and dart-define. Optimized '
          'CI/CD on Azure DevOps with static analysis, a custom lint and Git '
          'Hooks. Published and maintained the apps on Google Play, the App '
          'Store and different SmartPOS models.',
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
      'pt': 'Desenvolvi e mantive funcionalidades em uma SPA Angular de grande '
          'porte, utilizando RxJS, NgRx, Reactive Forms e lazy loading. '
          'Integrei APIs REST com autenticação JWT e componentes dos Design '
          'Systems PO UI e PrimeNG. Implementei testes unitários e E2E com '
          'Jasmine, Karma, Jest e Cypress. Otimizei pipelines de CI/CD no '
          'Azure DevOps com cache de dependências e execução incremental de '
          'tarefas via Nx. Apliquei boas práticas de desenvolvimento, análise '
          'estática, pair programming e code review, com apoio do GitHub '
          'Copilot.',
      'en': 'Built and maintained features in a large Angular SPA, using RxJS, '
          'NgRx, Reactive Forms and lazy loading. Integrated REST APIs with '
          'JWT authentication and components from the PO UI and PrimeNG Design '
          'Systems. Implemented unit and E2E tests with Jasmine, Karma, Jest '
          'and Cypress. Optimized CI/CD pipelines on Azure DevOps with '
          'dependency caching and incremental task execution via Nx. Applied '
          'development best practices, static analysis, pair programming and '
          'code review, supported by GitHub Copilot.',
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
      'pt': 'Desenvolvi de forma autônoma uma aplicação mobile para gestão '
          'financeira e fiscal de MEIs, da definição da arquitetura e do MVP '
          'até a segunda versão, publicada na Google Play e na App Store. '
          'Estruturei o app de forma modular feature-first, utilizando '
          'Flutter, Dart, BLoC/Cubit, Provider e princípios de inversão de '
          'dependência. Integrei APIs REST com autenticação JWT, refresh token '
          'e persistência local. Implementei o fluxo de onboarding para upload '
          'de certificados digitais A1 (.pfx/.p12), utilizados na emissão de '
          'NF-e e NFS-e. Criei um Design System próprio, com tokens e '
          'componentes reutilizáveis baseados no Material Design. Implementei '
          'a navegação com GoRouter e deep linking e o gerenciamento de '
          'ambientes via dart-define. Automatizei os builds e a distribuição '
          'iOS com GitHub Actions e Fastlane, incluindo publicação no '
          'TestFlight.',
      'en': 'Independently built a mobile app for the financial and tax '
          'management of MEIs (Brazilian micro-entrepreneurs), from defining '
          'the architecture and the MVP to the second version, published on '
          'Google Play and the App Store. Structured the app as modular '
          'feature-first, using Flutter, Dart, BLoC/Cubit, Provider and '
          'dependency inversion principles. Integrated REST APIs with JWT '
          'authentication, refresh token and local persistence. Implemented '
          'the onboarding flow for uploading A1 digital certificates '
          '(.pfx/.p12), used to issue NF-e and NFS-e invoices. Created an '
          'in-house Design System, with tokens and reusable components based '
          'on Material Design. Implemented navigation with GoRouter and deep '
          'linking, and environment management via dart-define. Automated iOS '
          'builds and distribution with GitHub Actions and Fastlane, including '
          'publishing to TestFlight.',
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
      'pt': 'Desenvolvi de forma autônoma uma aplicação web, da arquitetura à '
          'implementação do MVP, utilizando React, Next.js e TypeScript. '
          'Estruturei uma arquitetura modular e um Design System próprio com '
          '24 componentes reutilizáveis. Gerenciei o estado com Redux Toolkit '
          'e Context API e integrei APIs REST com Axios e autenticação JWT. '
          'Desenvolvi o back-end com Node.js, NestJS, TypeORM e PostgreSQL. '
          'Configurei CI/CD com GitHub Actions e Docker, com deploy em '
          'Kubernetes (GKE).',
      'en': 'Independently built a web application, from the architecture to the '
          'MVP implementation, using React, Next.js and TypeScript. Structured '
          'a modular architecture and an in-house Design System with 24 '
          'reusable components. Managed state with Redux Toolkit and Context '
          'API and integrated REST APIs with Axios and JWT authentication. '
          'Developed the back end with Node.js, NestJS, TypeORM and '
          'PostgreSQL. Set up CI/CD with GitHub Actions and Docker, deploying '
          'to Kubernetes (GKE).',
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
      'pt': 'Desenvolvi e mantive aplicações web com AngularJS, entregando novas '
          'funcionalidades e melhorias contínuas. Introduzi React com '
          'TypeScript em uma arquitetura de Micro Frontends, contribuindo para '
          'a evolução da estrutura front-end.',
      'en': 'Built and maintained web applications with AngularJS, delivering '
          'new features and continuous improvements. Introduced React with '
          'TypeScript into a Micro Frontends architecture, contributing to the '
          'evolution of the front-end structure.',
    },
  ),
  CvExperienceItem(
    company: 'Realiplasticos',
    period: 'Ago/2016 - Mar/2020',
    role: {
      'pt': 'Designer',
      'en': 'Designer',
    },
    description: {
      'pt': 'Desenvolvi e mantive o site institucional em PHP, com melhorias de '
          'interface e conteúdo e otimização para mecanismos de busca (SEO).',
      'en':
          'Built and maintained the company website in PHP, with interface and '
              'content improvements and search engine optimization (SEO).',
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
      'pt': 'Desenvolvi sistemas web e aplicativos mobile híbridos, incluindo '
          'APIs e publicação nas lojas, utilizando PhoneGap, AngularJS, PHP, '
          'MySQL e SQLite. Desenvolvi uma aplicação desktop em C# integrada a '
          'um dispositivo de monitoramento pulmonar por tomografia por '
          'impedância elétrica (EIT), com leitura de dados em tempo real e '
          'testes unitários.',
      'en': 'Built web systems and hybrid mobile apps, including APIs and '
          'publishing to the app stores, using PhoneGap, AngularJS, PHP, MySQL '
          'and SQLite. Built a C# desktop application integrated with a lung '
          'monitoring device using Electrical Impedance Tomography (EIT), with '
          'real-time data reading and unit tests.',
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
    shortDescription: {
      'pt': 'Desenvolvimento de aplicação fictícia de pagamentos para estudo '
          'de arquitetura em Flutter, utilizando Dart, MVVM, BLoC/Cubit, SOLID, '
          'WebView via biblioteca própria e testes automatizados',
      'en': 'Development of a fictional payments app to study Flutter '
          'architecture, using Dart, MVVM, BLoC/Cubit, SOLID principles, '
          'WebView via an in-house library and automated testing',
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
    shortDescription: {
      'pt': 'Desenvolvimento de site e portfólio pessoal em Flutter Web e '
          'Dart, com recursos de acessibilidade, internacionalização e testes '
          'automatizados',
      'en': 'Development of a personal website and portfolio in Flutter Web '
          'and Dart, with accessibility, internationalization and automated '
          'testing',
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
