import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'providers/week_provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => WeekProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)?.appTitle ?? 'Weekly Meal Planning',
      locale: context.watch<LocaleProvider>().locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('tr'), // Turkish
      ],
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          primary: Colors.black,
          secondary: Colors.grey[700]!,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade200,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
            }
            return const TextStyle(fontSize: 12);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return const IconThemeData(size: 28);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 60,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          primary: Colors.white,
          secondary: Colors.grey[300]!,
          brightness: Brightness.dark,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.grey.shade800,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
            }
            return const TextStyle(fontSize: 12);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            return const IconThemeData(size: 28);
          }),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 60,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      themeMode: context.watch<ThemeProvider>().themeMode,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomeTab(),
    ExploreTab(),
    InventoryTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeekProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          height: 56,
          elevation: 0,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.homeTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.search_outlined),
              selectedIcon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.exploreTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.shopping_basket_outlined),
              selectedIcon: const Icon(Icons.shopping_basket),
              label: AppLocalizations.of(context)!.inventoryTab,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settingsTab,
            ),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  String _formatDateRange(BuildContext context, DateTime start, DateTime end) {
    final now = DateTime.now();
    final currentWeekStart = now.subtract(Duration(days: now.weekday - 1));
    final difference = start.difference(currentWeekStart).inDays;
    
    print('Current week start: $currentWeekStart');
    print('Selected week start: $start');
    print('Difference in days: $difference');

    if (difference == 0) return 'This Week';
    if (difference == -7) return 'Last Week';
    if (difference == 6 || difference == 7) return 'Next Week';
    
    final startStr = "${start.month}/${start.day}";
    final endStr = "${end.month}/${end.day}";
    return "$startStr - $endStr";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final weekProvider = Provider.of<WeekProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.appTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share_outlined),
                      onPressed: () {
                        // TODO: Implement share functionality
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // TODO: Implement more options menu
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    weekProvider.previousWeek();
                  },
                ),
                Text(
                  _formatDateRange(
                    context,
                    weekProvider.weekStart,
                    weekProvider.weekEnd,
                  ),
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    weekProvider.nextWeek();
                  },
                ),
              ],
            ),
          ],
        ),
        toolbarHeight: 100,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7, // One item per day of the week
        itemBuilder: (context, dayIndex) {
          return DaySection(dayIndex: dayIndex);
        },
      ),
    );
  }
}

class DaySection extends StatelessWidget {
  final int dayIndex;

  const DaySection({super.key, required this.dayIndex});

  String _getDayName(BuildContext context, DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final weekProvider = Provider.of<WeekProvider>(context);
    final dayDate = weekProvider.weekStart.add(Duration(days: dayIndex));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDayName(context, dayDate),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  // TODO: Navigate to detailed day view
                },
              ),
            ],
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.85,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            MealSlot(mealType: 'Breakfast'),
            MealSlot(mealType: 'Lunch'),
            MealSlot(mealType: 'Snacks'),
            MealSlot(mealType: 'Dinner'),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }
}

class MealSlot extends StatelessWidget {
  final String mealType;

  const MealSlot({super.key, required this.mealType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // TODO: Handle meal slot tap
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 32,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  mealType,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.exploreTab,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Text(
          l10n.exploreContent,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class InventoryTab extends StatelessWidget {
  const InventoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.inventoryTab,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Text(
          l10n.inventoryContent,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  String getThemeModeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.system:
        return l10n.systemTheme;
      case ThemeMode.light:
        return l10n.lightTheme;
      case ThemeMode.dark:
        return l10n.darkTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          l10n.settingsTab,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              l10n.themeSettings,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
            trailing: const Icon(Icons.brightness_medium),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.systemTheme,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children: [
                            Icon(
                              Icons.brightness_auto,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.systemTheme,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: ThemeMode.system,
                        groupValue: themeProvider.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            themeProvider.setThemeMode(value);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children: [
                            Icon(
                              Icons.light_mode,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.lightTheme,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: ThemeMode.light,
                        groupValue: themeProvider.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            themeProvider.setThemeMode(value);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<ThemeMode>(
                        title: Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.darkTheme,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: ThemeMode.dark,
                        groupValue: themeProvider.themeMode,
                        onChanged: (ThemeMode? value) {
                          if (value != null) {
                            themeProvider.setThemeMode(value);
                          }
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: Text(
              l10n.languageSettings,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
              ),
            ),
            trailing: const Icon(Icons.language),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.languageSettings,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RadioListTile<Locale?>(
                        title: Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: theme.colorScheme.onSurface,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.systemLanguage,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: null,
                        groupValue: localeProvider.locale,
                        onChanged: (value) {
                          localeProvider.setLocale(value);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<Locale?>(
                        title: Row(
                          children: [
                            const Text(
                              "🇹🇷",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.turkish,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: const Locale('tr'),
                        groupValue: localeProvider.locale,
                        onChanged: (value) {
                          localeProvider.setLocale(value);
                          Navigator.pop(context);
                        },
                      ),
                      RadioListTile<Locale?>(
                        title: Row(
                          children: [
                            const Text(
                              "🇬🇧",
                              style: TextStyle(fontSize: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.english,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        value: const Locale('en'),
                        groupValue: localeProvider.locale,
                        onChanged: (value) {
                          localeProvider.setLocale(value);
                          Navigator.pop(context);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

