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
    'en' => 'Software Developer with more than 8 years of experience, '
        'including over 5 in hybrid mobile development. Works on '
        'mobile and web applications, defining architecture, reusable '
        'components and Design Systems. Solid knowledge of Flutter, '
        'Dart, BLoC/Cubit, MVVM, REST APIs, automated testing and '
        'native integration. Experienced with SmartPOS, Offline '
        'First, CI/CD, app publishing and shared libraries. Fullstack '
        'experience and use of AI in development, automation and code '
        'quality.',
    _ => 'Desenvolvedor de Software com mais de 8 anos de experiência, '
        'sendo mais de 5 em desenvolvimento mobile híbrido. Atuação '
        'em aplicações mobile e web, com definição de arquitetura, '
        'componentes reutilizáveis e Design Systems. Sólidos '
        'conhecimentos em Flutter, Dart, BLoC/Cubit, MVVM, APIs REST, '
        'testes automatizados e integração nativa. Experiência com '
        'SmartPOS, Offline First, CI/CD, publicação de apps e '
        'bibliotecas compartilhadas. Vivência fullstack e uso de IA '
        'no desenvolvimento, na automação e na qualidade de código.',
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
      'pt': 'Evolução do backoffice de gestão de conteúdo do app '
          '(shortcuts da home, menu e tab bar), usado por times '
          'internos da Argentina, do Brasil e do México, com '
          'validação das configurações cadastradas nos apps de teste '
          'Android e iOS. CRUD de '
          'banners de campanhas com live preview, em React e '
          'TypeScript, com formulários em Formik e '
          'validação com Yup. Interfaces com '
          'internacionalização (i18n), os Design Systems internos '
          'Andes e AndesX, SCSS e o framework interno Nordic. BFF em '
          'Node.js (Nordic, baseado em Express) para integração REST '
          'com as APIs em Go. Criação de endpoints em Go com '
          'arquitetura hexagonal, MySQL e testes unitários. Testes '
          'unitários com Jest, elevando a cobertura do front-end de 0 '
          'para mais de 80%. CI/CD com '
          'GitHub e Fury e monitoramento com Datadog, Kibana e '
          'Grafana. Pair programming e code review, apoiando o time '
          'no desenvolvimento e na refatoração do front-end, em '
          'Kanban com Jira. Uso de Claude Code, ChatGPT e Cursor para '
          'gerar testes, investigar bugs e criar funcionalidades, com '
          'configuração do CLAUDE.md no front-end e plugin para Claude Code que '
          'automatiza a atualização da URL dos shortcuts.',
      'en': "Evolved the app's content management backoffice (home "
          'shortcuts, menu and tab bar), used by internal teams in '
          'Argentina, Brazil and Mexico, validating the registered '
          'settings in the Android and iOS test apps. Campaign banner '
          'CRUD with '
          'live preview, in React and TypeScript, with forms in Formik '
          'and validation with Yup. '
          'Interfaces with internationalization (i18n), the internal '
          'Andes and AndesX Design Systems, SCSS and the internal '
          'Nordic framework. Node.js BFF (Nordic, based on Express) '
          'for REST integration with the Go APIs. Built Go endpoints '
          'with hexagonal architecture, MySQL and unit tests. Unit '
          'tests with Jest, raising front-end coverage from 0 to over '
          '80%. CI/CD with GitHub and '
          'Fury, and monitoring with Datadog, Kibana and Grafana. '
          'Pair programming and code review, supporting the team in '
          'front-end development and refactoring, using Kanban with '
          'Jira. Use of Claude Code, ChatGPT and Cursor to generate '
          'tests, investigate bugs and build features, setting up the '
          'CLAUDE.md for the front end and a Claude Code plugin that '
          'automates updating the shortcuts URL.',
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
      'pt': 'Referência técnica na equipe mobile de 3 desenvolvedores; '
          'conduzi a análise comparativa entre Flutter, React Native, '
          'Ionic e Xamarin que levou à adoção do Flutter. Definição '
          'da arquitetura, das bibliotecas e dos padrões técnicos, '
          'alinhados com outras equipes. Pair programming, code '
          'review via Pull Requests, refinamento e estimativas com o '
          'PO. Apps Minha Comanda Eletrônica e Minha Governança '
          'Hoteleira para Android, iOS e SmartPOS, com BLoC/Cubit, '
          'arquitetura em camadas, Repository Pattern e injeção de '
          'dependência (get_it). Offline First com Hive, SQLite e '
          'SharedPreferences, detecção de conectividade e '
          'sincronização posterior dos pedidos. APIs REST via Dio '
          '(interceptors) e Dartz (Either e imutabilidade), e tempo '
          'real via SignalR (WebSockets) para notificações de '
          'pagamento. Biblioteca de componentes e tokens do Design '
          'System corporativo, reutilizada entre as aplicações. '
          'Biblioteca Flutter de integração com modelos de SmartPOS '
          'via MethodChannel, abstraindo as particularidades de cada '
          'dispositivo. Pagamentos com Cielo, Adyen, Getnet, '
          'PagSeguro, Rede e SafraPay (Pix e TEF), leitura de cartões '
          'por NFC e impressão de comprovantes e relatórios no '
          'SmartPOS. Monitoramento com Datadog (RUM, logs e '
          'rastreamento HTTP) e internacionalização em pt, en e es '
          'com Crowdin. 4 ambientes e builds por adquirente via '
          'flavors/dart-define. CI/CD no Azure DevOps com redução do '
          'tempo de execução, lint customizado e git hooks de análise '
          'estática. Publicação na Google Play, na App Store e em '
          'modelos de SmartPOS.',
      'en': 'Technical reference on a 3-developer mobile team; led the '
          'comparative analysis of Flutter, React Native, Ionic and '
          'Xamarin that led to adopting Flutter. Defined the '
          'architecture, libraries and technical standards, aligned '
          'with other teams. Pair programming, code review via Pull '
          'Requests, refinement and estimation with the PO. Minha '
          'Comanda Eletrônica and Minha Governança Hoteleira apps for '
          'Android, iOS and SmartPOS, with BLoC/Cubit, layered '
          'architecture, the Repository Pattern and dependency '
          'injection (get_it). Offline First with Hive, SQLite and '
          'SharedPreferences, connectivity detection and later order '
          'synchronization. REST APIs via Dio (interceptors) and '
          'Dartz (Either and immutability), and real-time payment '
          'notifications via SignalR (WebSockets). Component and '
          'token library of the corporate Design System, reused '
          'across the applications. Flutter library integrating '
          'SmartPOS models via MethodChannel, abstracting away each '
          "device's specifics. Payments with Cielo, Adyen, Getnet, "
          'PagSeguro, Rede and SafraPay (Pix and TEF), NFC card '
          'reading and printing of receipts and reports on SmartPOS. '
          'Monitoring with Datadog (RUM, logs and HTTP tracing) and '
          'internationalization in pt, en and es with Crowdin. 4 '
          'environments and per-acquirer builds via '
          'flavors/dart-define. CI/CD on Azure DevOps with reduced '
          'execution time, a custom lint and static-analysis git '
          'hooks. Published to Google Play, the App Store and '
          'SmartPOS models.',
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
      'pt': 'Funcionalidades, correções e melhorias em uma SPA Angular '
          'de grande porte, com RxJS, NgRx, Reactive Forms e lazy '
          'loading de módulos. APIs REST e autenticação JWT com '
          'serviços, HTTP Interceptors e injeção de dependência. '
          'Interfaces responsivas com HTML5, SCSS e componentes de '
          'Design System (PO UI e PrimeNG), documentados no '
          'Storybook. Testes unitários com Jasmine, Karma e Jest e '
          'testes E2E com Cypress, aplicando Clean Code e SOLID. '
          'CI/CD no Azure DevOps com cache de dependências e execução '
          'incremental (Nx affected) de lint, testes e build, '
          'reduzindo o tempo dos pipelines. ESLint, Prettier, '
          'Conventional Commits, Git Hooks e SonarQube; pair '
          'programming e code review em time ágil (Scrum). Uso do '
          'GitHub Copilot e de IA no desenvolvimento, na refatoração '
          'e na manutenção de código.',
      'en': 'Features, fixes and improvements in a large Angular SPA, '
          'with RxJS, NgRx, Reactive Forms and lazy-loaded modules. '
          'REST APIs and JWT authentication with services, HTTP '
          'Interceptors and dependency injection. Responsive '
          'interfaces with HTML5, SCSS and Design System components '
          '(PO UI and PrimeNG), documented in Storybook. Unit tests '
          'with Jasmine, Karma and Jest and E2E tests with Cypress, '
          'applying Clean Code and SOLID. CI/CD on Azure DevOps with '
          'dependency caching and incremental runs (Nx affected) of '
          'lint, tests and build, reducing pipeline time. ESLint, '
          'Prettier, Conventional Commits, Git Hooks and SonarQube; '
          'pair programming and code review on an agile (Scrum) team. '
          'Use of GitHub Copilot and AI in development, refactoring '
          'and code maintenance.',
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
      'pt': 'Condução autônoma do app cross-platform de gestão '
          'financeira e fiscal para MEIs, da arquitetura e do MVP até '
          'a segunda versão, com Flutter/Dart e publicação na Google '
          'Play e App Store. Arquitetura modular feature-first, '
          'separando UI, estado (BLoC/Cubit) e serviços, com injeção '
          'de dependências via Provider, inversão de dependência e '
          'Value Objects. APIs REST (http e JSON) com autenticação '
          'JWT e refresh token; persistência local com '
          'SharedPreferences. Upload do certificado digital A1 '
          '(.pfx/.p12) no onboarding para emissão de NF-e e NFS-e, '
          'com seleção de arquivo e permissões de armazenamento. '
          'Design System próprio com design tokens e componentes '
          'baseados no Material Design. GoRouter com deep linking e '
          'ambientes via --dart-define. Firebase: Crashlytics, Remote '
          'Config (feature flags) e push notifications com FCM e '
          'notificações locais. CI/CD com GitHub Actions e Fastlane '
          '(Match), automatizando o build e a distribuição iOS no '
          'TestFlight a partir de tags e versionamento semântico.',
      'en': 'Independently led the cross-platform financial and tax '
          'management app for MEIs (Brazilian micro-entrepreneurs), '
          'from architecture and MVP to the second version, with '
          'Flutter/Dart and publishing on Google Play and the App '
          'Store. Modular feature-first architecture, separating UI, '
          'state (BLoC/Cubit) and services, with dependency injection '
          'via Provider, dependency inversion and Value Objects. REST '
          'APIs (http and JSON) with JWT authentication and refresh '
          'token; local persistence with SharedPreferences. Upload of '
          'the A1 digital certificate (.pfx/.p12) during onboarding '
          'to issue NF-e and NFS-e invoices, with file picking and '
          'storage permissions. In-house Design System with design '
          'tokens and components based on Material Design. GoRouter '
          'with deep linking and environments via --dart-define. '
          'Firebase: Crashlytics, Remote Config (feature flags) and '
          'push notifications with FCM and local notifications. CI/CD '
          'with GitHub Actions and Fastlane (Match), automating the '
          'iOS build and TestFlight distribution from tags and '
          'semantic versioning.',
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
      'pt': 'Condução autônoma da aplicação React: arquitetura, MVP, '
          'estrutura e padrões técnicos. Interfaces com React, '
          'Next.js e TypeScript (HTML5, CSS3, SCSS e CSS Modules), em '
          'Component-Based e Modular Architecture organizada por área '
          'do sistema. Design System próprio com 24 Reusable '
          'Components (Table, Modal, Tabs, Pagination e Toast). '
          'Estado com Redux Toolkit e Context API; REST API com Axios '
          'e autenticação JWT, com Separation of Concerns. Back-end '
          'em Node.js com NestJS, TypeORM, PostgreSQL e Swagger. '
          'ESLint, Prettier e fluxo de Git com branches de dev, '
          'staging e produção. CI/CD com GitHub Actions, Docker e '
          'deploy em Kubernetes (GKE).',
      'en': 'Independently led the React application: architecture, '
          'MVP, structure and technical standards. Interfaces with '
          'React, Next.js and TypeScript (HTML5, CSS3, SCSS and CSS '
          'Modules), in a Component-Based and Modular Architecture '
          'organized by system area. In-house Design System with 24 '
          'Reusable Components (Table, Modal, Tabs, Pagination and '
          'Toast). State with Redux Toolkit and Context API; REST API '
          'with Axios and JWT authentication, with Separation of '
          'Concerns. Node.js back end with NestJS, TypeORM, '
          'PostgreSQL and Swagger. ESLint, Prettier and a Git flow '
          'with dev, staging and production branches. CI/CD with '
          'GitHub Actions, Docker and deployment to Kubernetes (GKE).',
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
      'pt': 'Evolução e manutenção de aplicações AngularJS, com novas '
          'funcionalidades e melhorias contínuas. Introdução de React '
          'com TypeScript em arquitetura de Micro Frontends. '
          'Interfaces personalizadas para diferentes clientes.',
      'en': 'Evolved and maintained AngularJS applications, with new '
          'features and continuous improvements. Introduced React '
          'with TypeScript into a Micro Frontends architecture. '
          'Custom interfaces for different clients.',
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
      'pt': 'Atuação autônoma em sistemas web e apps mobile híbridos '
          'com PhoneGap, AngularJS, SQLite, PHP e MySQL, da '
          'implementação à publicação na Google Play e App Store. '
          'Segunda versão de app mobile com PhoneGap e AngularJS, '
          'incluindo a definição da arquitetura. APIs em PHP com '
          'CodeIgniter para o app mobile. App desktop em C# para '
          'monitoramento pulmonar por tomografia por impedância '
          'elétrica (EIT), integrado via USB a uma cinta torácica, '
          'com leituras em tempo real das áreas ventiladas e '
          'histórico; implementação de testes unitários e de novos '
          'parâmetros com polimorfismo.',
      'en': 'Independently built web systems and hybrid mobile apps '
          'with PhoneGap, AngularJS, SQLite, PHP and MySQL, from '
          'implementation to publishing on Google Play and the App '
          'Store. Second version of a mobile app with PhoneGap and '
          'AngularJS, including defining the architecture. PHP APIs '
          'with CodeIgniter for the mobile app. C# desktop app for '
          'lung monitoring with Electrical Impedance Tomography '
          '(EIT), connected over USB to a chest belt, with real-time '
          'readings of the ventilated areas and history; implemented '
          'unit tests and new parameters with polymorphism.',
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
