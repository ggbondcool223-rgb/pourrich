import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_pour_rich_entity.dart';

class PourRichDatabase extends GetxService {
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'pour_rich.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE monopoly_game_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        current_position INTEGER NOT NULL DEFAULT 1,
        total_grids INTEGER NOT NULL DEFAULT 40,
        total_wins INTEGER NOT NULL DEFAULT 0,
        best_record INTEGER NOT NULL DEFAULT 0,
        current_guess_count INTEGER NOT NULL DEFAULT 0,
        current_attempt_count INTEGER NOT NULL DEFAULT 0,
        has_shown_guide INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE water_challenge_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_score INTEGER NOT NULL DEFAULT 0,
        level INTEGER NOT NULL DEFAULT 1,
        highest_score INTEGER NOT NULL DEFAULT 0,
        consecutive_wins INTEGER NOT NULL DEFAULT 0,
        total_challenges INTEGER NOT NULL DEFAULT 0,
        total_success INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE water_challenge_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        target_amount INTEGER NOT NULL,
        actual_amount INTEGER NOT NULL,
        error_amount INTEGER NOT NULL,
        score INTEGER NOT NULL,
        is_success INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE water_challenge_achievement (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        achievement_key TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        is_achieved INTEGER NOT NULL DEFAULT 0,
        achieved_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE trivia (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        icon TEXT NOT NULL,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        category TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE trivia_read_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trivia_id INTEGER NOT NULL,
        read_at TEXT NOT NULL,
        FOREIGN KEY (trivia_id) REFERENCES trivia (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE trivia_favorite (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trivia_id INTEGER NOT NULL,
        favorited_at TEXT NOT NULL,
        FOREIGN KEY (trivia_id) REFERENCES trivia (id) ON DELETE CASCADE,
        UNIQUE (trivia_id)
      )
    ''');
    await db.execute('''
      CREATE TABLE financial_guide (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        stage TEXT NOT NULL,
        age_range TEXT NOT NULL,
        icon TEXT NOT NULL,
        border_color TEXT NOT NULL,
        description TEXT NOT NULL,
        advice TEXT NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE financial_guide_allocation (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        guide_id INTEGER NOT NULL,
        investment_type TEXT NOT NULL,
        percentage INTEGER NOT NULL,
        sort_order INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (guide_id) REFERENCES financial_guide (id) ON DELETE CASCADE
      )
    ''');
    await _createNewTables(db);
    await _initializeDefaultData(db);
    await _initializeNewFeatureData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createNewTables(db);
      await _initializeNewFeatureData(db);
    }
    if (oldVersion < 3) {
      await _createNewTables(db);
      await _initializeNewFeatureData(db);
    }
  }

  Future<void> _createNewTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS daily_tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        task_key TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        target_value INTEGER NOT NULL DEFAULT 1,
        current_value INTEGER NOT NULL DEFAULT 0,
        reward_coins INTEGER NOT NULL DEFAULT 10,
        is_completed INTEGER NOT NULL DEFAULT 0,
        task_date TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS savings_goals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        target_amount REAL NOT NULL,
        current_amount REAL NOT NULL DEFAULT 0,
        description TEXT,
        deadline TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        completed_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS savings_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        goal_id INTEGER NOT NULL,
        amount REAL NOT NULL,
        type TEXT NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY (goal_id) REFERENCES savings_goals (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS trivia_questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        trivia_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        option1 TEXT NOT NULL,
        option2 TEXT NOT NULL,
        option3 TEXT NOT NULL,
        option4 TEXT NOT NULL,
        correct_option INTEGER NOT NULL,
        FOREIGN KEY (trivia_id) REFERENCES trivia (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS quiz_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id INTEGER NOT NULL,
        selected_option INTEGER NOT NULL,
        is_correct INTEGER NOT NULL DEFAULT 0,
        coins_earned INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (question_id) REFERENCES trivia_questions (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS coins_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount INTEGER NOT NULL,
        source TEXT NOT NULL,
        description TEXT,
        created_at TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS global_achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        achievement_key TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        rarity TEXT NOT NULL,
        reward_coins INTEGER NOT NULL DEFAULT 0,
        is_achieved INTEGER NOT NULL DEFAULT 0,
        achieved_at TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS user_coins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        total_coins INTEGER NOT NULL DEFAULT 0,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  Future<void> _initializeNewFeatureData(Database db) async {
    final coinsCheck = await db.query('user_coins', limit: 1);
    if (coinsCheck.isEmpty) {
      await db.insert('user_coins', {
        'total_coins': 0,
        'updated_at': DateTime.now().toIso8601String(),
      });
    }
    final achievementsCheck = await db.query('global_achievements', limit: 1);
    if (achievementsCheck.isEmpty) {
      await _initializeGlobalAchievements(db);
    }
    final questionsCheck = await db.query('trivia_questions', limit: 1);
    if (questionsCheck.isEmpty) {
      await _initializeTriviaQuestions(db);
    }
  }

  Future<void> _initializeGlobalAchievements(Database db) async {
    final achievements = [
      {
        'achievement_key': 'monopoly_first_win',
        'name': 'First Victory',
        'description': 'Complete your first Monopoly game',
        'category': 'monopoly',
        'rarity': 'bronze',
        'reward_coins': 50,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'monopoly_win_10',
        'name': 'Monopoly Expert',
        'description': 'Win 10 Monopoly games',
        'category': 'monopoly',
        'rarity': 'silver',
        'reward_coins': 100,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'monopoly_perfect_game',
        'name': 'Perfect Game',
        'description': 'Win a game with minimum guesses',
        'category': 'monopoly',
        'rarity': 'gold',
        'reward_coins': 200,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'challenge_first_success',
        'name': 'First Success',
        'description': 'Complete your first water challenge',
        'category': 'challenge',
        'rarity': 'bronze',
        'reward_coins': 30,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'challenge_perfect_shot',
        'name': 'Perfect Shot',
        'description': 'Complete a challenge with 0ml error',
        'category': 'challenge',
        'rarity': 'gold',
        'reward_coins': 150,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'challenge_level_10',
        'name': 'Master Level',
        'description': 'Reach level 10 in water challenge',
        'category': 'challenge',
        'rarity': 'silver',
        'reward_coins': 120,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'challenge_streak_10',
        'name': 'Winning Streak',
        'description': 'Win 10 challenges in a row',
        'category': 'challenge',
        'rarity': 'diamond',
        'reward_coins': 300,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'trivia_read_all',
        'name': 'Knowledge Seeker',
        'description': 'Read all trivia articles',
        'category': 'trivia',
        'rarity': 'gold',
        'reward_coins': 200,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'quiz_master',
        'name': 'Quiz Master',
        'description': 'Answer 50 quiz questions correctly',
        'category': 'trivia',
        'rarity': 'silver',
        'reward_coins': 150,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'quiz_perfect_score',
        'name': 'Perfect Score',
        'description': 'Get 10 correct answers in a row',
        'category': 'trivia',
        'rarity': 'gold',
        'reward_coins': 180,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'savings_first_goal',
        'name': 'First Goal',
        'description': 'Complete your first savings goal',
        'category': 'financial',
        'rarity': 'bronze',
        'reward_coins': 80,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'savings_goal_5',
        'name': 'Goal Achiever',
        'description': 'Complete 5 savings goals',
        'category': 'financial',
        'rarity': 'silver',
        'reward_coins': 150,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'savings_1000',
        'name': 'Saver Pro',
        'description': 'Save \$1000 in total',
        'category': 'financial',
        'rarity': 'gold',
        'reward_coins': 200,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'daily_tasks_7',
        'name': 'Week Warrior',
        'description': 'Complete daily tasks for 7 consecutive days',
        'category': 'global',
        'rarity': 'silver',
        'reward_coins': 100,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'coins_collector',
        'name': 'Coin Collector',
        'description': 'Earn 1000 coins in total',
        'category': 'global',
        'rarity': 'gold',
        'reward_coins': 0,
        'is_achieved': 0,
      },
      {
        'achievement_key': 'all_features',
        'name': 'Explorer',
        'description': 'Use all app features at least once',
        'category': 'global',
        'rarity': 'diamond',
        'reward_coins': 500,
        'is_achieved': 0,
      },
    ];
    for (final achievement in achievements) {
      await db.insert('global_achievements', achievement);
    }
  }

  Future<void> _initializeTriviaQuestions(Database db) async {
    final triviaList = await db.query('trivia');
    for (final trivia in triviaList) {
      final triviaId = trivia['id'] as int;
      final title = trivia['title'] as String;
      Map<String, dynamic>? questionData;
      if (title == 'Human Body Temperature') {
        questionData = {
          'trivia_id': triviaId,
          'question':
              'What is the most comfortable temperature for the human body?',
          'correct_answer': '22-24°C',
          'option1': '22-24°C',
          'option2': '37°C',
          'option3': '18-20°C',
          'option4': '27-29°C',
          'correct_option': 1,
        };
      } else if (title == 'Sound of Water') {
        questionData = {
          'trivia_id': triviaId,
          'question':
              'Why do hot water and cold water make different sounds when poured?',
          'correct_answer': 'Molecules move at different speeds',
          'option1': 'Different container shapes',
          'option2': 'Molecules move at different speeds',
          'option3': 'Air pressure differences',
          'option4': 'Water density changes',
          'correct_option': 2,
        };
      } else if (title == 'Apple Buoyancy') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'Why can apples float on water?',
          'correct_answer': 'Their density is less than water',
          'option1': 'They have air pockets inside',
          'option2': 'Their density is less than water',
          'option3': 'They repel water molecules',
          'option4': 'Surface tension supports them',
          'correct_option': 2,
        };
      } else if (title == 'Bee Flight') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'How do bees fly despite having small wings?',
          'correct_answer': 'Rapidly vibrating their wings',
          'option1': 'Using jet propulsion',
          'option2': 'Gliding on air currents',
          'option3': 'Rapidly vibrating their wings',
          'option4': 'Magnetic field assistance',
          'correct_option': 3,
        };
      } else if (title == 'Giraffe Sleep') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'How many hours do giraffes sleep per day?',
          'correct_answer': '2 hours',
          'option1': '8 hours',
          'option2': '5 hours',
          'option3': '2 hours',
          'option4': '12 hours',
          'correct_option': 3,
        };
      } else if (title == 'Brain Power') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'What percentage of body energy does the brain use?',
          'correct_answer': '20%',
          'option1': '5%',
          'option2': '20%',
          'option3': '50%',
          'option4': '10%',
          'correct_option': 2,
        };
      } else if (title == 'Octopus Hearts') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'How many hearts do octopuses have?',
          'correct_answer': 'Three',
          'option1': 'One',
          'option2': 'Two',
          'option3': 'Three',
          'option4': 'Four',
          'correct_option': 3,
        };
      } else if (title == 'Honey Never Spoils') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'How long can honey last without spoiling?',
          'correct_answer': 'Indefinitely',
          'option1': '1 year',
          'option2': '10 years',
          'option3': 'Indefinitely',
          'option4': '100 years',
          'correct_option': 3,
        };
      } else if (title == 'Butterfly Taste') {
        questionData = {
          'trivia_id': triviaId,
          'question': 'What body part do butterflies use to taste?',
          'correct_answer': 'Their feet',
          'option1': 'Their antennae',
          'option2': 'Their feet',
          'option3': 'Their proboscis',
          'option4': 'Their wings',
          'correct_option': 2,
        };
      } else if (title == 'Elephant Memory') {
        questionData = {
          'trivia_id': triviaId,
          'question':
              'For how long can elephants remember water source locations?',
          'correct_answer': 'Decades',
          'option1': 'A few weeks',
          'option2': 'A few months',
          'option3': 'A few years',
          'option4': 'Decades',
          'correct_option': 4,
        };
      }
      if (questionData != null) {
        await db.insert('trivia_questions', questionData);
      }
    }
  }

  Future<void> _initializeDefaultData(Database db) async {
    await db.insert('monopoly_game_progress', {
      'current_position': 1,
      'total_grids': 40,
      'total_wins': 0,
      'best_record': 0,
      'current_guess_count': 0,
      'current_attempt_count': 0,
      'has_shown_guide': 0,
      'updated_at': DateTime.now().toIso8601String(),
    });
    await db.insert('water_challenge_profile', {
      'total_score': 0,
      'level': 1,
      'highest_score': 0,
      'consecutive_wins': 0,
      'total_challenges': 0,
      'total_success': 0,
      'updated_at': DateTime.now().toIso8601String(),
    });
    final achievements = [
      {
        'achievement_key': 'first_success',
        'name': 'First Success',
        'description': 'Complete your first challenge successfully',
        'is_achieved': 0,
      },
      {
        'achievement_key': 'perfect_shot',
        'name': 'Perfect Shot',
        'description': 'Complete a challenge with 0ml error',
        'is_achieved': 0,
      },
      {
        'achievement_key': 'win_streak_10',
        'name': 'Flawless',
        'description': 'Win 10 challenges in a row',
        'is_achieved': 0,
      },
      {
        'achievement_key': 'level_10',
        'name': 'Master',
        'description': 'Reach level 10',
        'is_achieved': 0,
      },
      {
        'achievement_key': 'challenge_100',
        'name': 'Persistent',
        'description': 'Complete 100 challenges',
        'is_achieved': 0,
      },
    ];
    for (final achievement in achievements) {
      await db.insert('water_challenge_achievement', achievement);
    }
    final triviaList = [
      {
        'icon': '🌡️',
        'title': 'Human Body Temperature',
        'content':
            'The most comfortable temperature for the human body is 22-24°C, not 37°C. 37°C is the internal body temperature, while the skin temperature is usually lower.',
        'category': 'Human Body',
        'sort_order': 1,
      },
      {
        'icon': '💧',
        'title': 'Sound of Water',
        'content':
            'Water makes different sounds at different temperatures. Hot water and cold water pour differently because molecules move at different speeds.',
        'category': 'Science',
        'sort_order': 2,
      },
      {
        'icon': '🍎',
        'title': 'Apple Buoyancy',
        'content':
            'Apples can float on water because their density is less than water. This is why apples float in soup.',
        'category': 'Science',
        'sort_order': 3,
      },
      {
        'icon': '🌙',
        'title': 'Moon Color',
        'content':
            'The moon appears white during the day and yellow at night due to atmospheric light scattering.',
        'category': 'Astronomy',
        'sort_order': 4,
      },
      {
        'icon': '🐝',
        'title': 'Bee Flight',
        'content':
            'According to aerodynamic principles, bees\' wings are too small to theoretically allow flight. But bees solve this problem by rapidly vibrating their wings.',
        'category': 'Nature',
        'sort_order': 5,
      },
      {
        'icon': '🌊',
        'title': 'Ocean Depth',
        'content':
            'Humans have explored only 5% of the ocean, with 95% still unknown. This is less than our knowledge of outer space.',
        'category': 'Nature',
        'sort_order': 6,
      },
      {
        'icon': '🦒',
        'title': 'Giraffe Sleep',
        'content':
            'Giraffes only need 2 hours of sleep per day and usually sleep standing up. This is to be ready for predators at any time.',
        'category': 'Animals',
        'sort_order': 7,
      },
      {
        'icon': '🧠',
        'title': 'Brain Power',
        'content':
            'The human brain uses about 20% of the body\'s energy despite being only 2% of body weight. It consumes the same power as a 20-watt light bulb.',
        'category': 'Human Body',
        'sort_order': 8,
      },
      {
        'icon': '⚡',
        'title': 'Lightning Speed',
        'content':
            'Lightning is five times hotter than the surface of the sun, reaching temperatures of about 30,000°C. It travels at speeds of up to 220,000 km/h.',
        'category': 'Science',
        'sort_order': 9,
      },
      {
        'icon': '🐙',
        'title': 'Octopus Hearts',
        'content':
            'Octopuses have three hearts. Two pump blood to the gills, while the third pumps blood to the rest of the body.',
        'category': 'Animals',
        'sort_order': 10,
      },
      {
        'icon': '🌍',
        'title': 'Earth Rotation',
        'content':
            'The Earth rotates at about 1,670 km/h at the equator, but you don\'t feel it because everything around you is moving at the same speed.',
        'category': 'Astronomy',
        'sort_order': 11,
      },
      {
        'icon': '🍯',
        'title': 'Honey Never Spoils',
        'content':
            'Honey can last indefinitely. Archaeologists have found 3,000-year-old honey in Egyptian tombs that was still edible.',
        'category': 'Science',
        'sort_order': 12,
      },
      {
        'icon': '🦋',
        'title': 'Butterfly Taste',
        'content':
            'Butterflies taste with their feet. They land on flowers to taste if they are good to eat before feeding.',
        'category': 'Animals',
        'sort_order': 13,
      },
      {
        'icon': '🌵',
        'title': 'Cactus Water Storage',
        'content':
            'A large cactus can store up to 200 gallons of water and survive for two years without rain.',
        'category': 'Nature',
        'sort_order': 14,
      },
      {
        'icon': '👁️',
        'title': 'Eye Movement',
        'content':
            'Your eyes can distinguish approximately 10 million different colors and move about 50 times per second.',
        'category': 'Human Body',
        'sort_order': 15,
      },
      {
        'icon': '🌟',
        'title': 'Star Light',
        'content':
            'When you look at stars, you\'re looking back in time. The light from distant stars can take millions of years to reach Earth.',
        'category': 'Astronomy',
        'sort_order': 16,
      },
      {
        'icon': '🐘',
        'title': 'Elephant Memory',
        'content':
            'Elephants have exceptional memories and can remember locations of water sources for decades. They can also recognize hundreds of individual elephants.',
        'category': 'Animals',
        'sort_order': 17,
      },
      {
        'icon': '💎',
        'title': 'Diamond Formation',
        'content':
            'Diamonds are formed under extreme pressure and temperature deep in the Earth, typically 100 miles below the surface, over billions of years.',
        'category': 'Science',
        'sort_order': 18,
      },
      {
        'icon': '🌺',
        'title': 'Plant Communication',
        'content':
            'Plants can communicate with each other through underground fungal networks, sharing nutrients and warning signals about pests.',
        'category': 'Nature',
        'sort_order': 19,
      },
      {
        'icon': '⏰',
        'title': 'Time Perception',
        'content':
            'Time seems to speed up as you age because each year becomes a smaller percentage of your total life experience.',
        'category': 'Human Body',
        'sort_order': 20,
      },
      {
        'icon': '🌈',
        'title': 'Rainbow Distance',
        'content':
            'You can never reach the end of a rainbow. As you move, the rainbow moves with you because it\'s an optical illusion caused by light refraction.',
        'category': 'Science',
        'sort_order': 21,
      },
      {
        'icon': '🦈',
        'title': 'Shark Age',
        'content':
            'Sharks have been around for more than 400 million years, which means they pre-date trees and the rings of Saturn.',
        'category': 'Animals',
        'sort_order': 22,
      },
      {
        'icon': '❄️',
        'title': 'Snowflake Uniqueness',
        'content':
            'No two snowflakes are exactly alike. Each one forms unique patterns based on temperature and humidity conditions.',
        'category': 'Nature',
        'sort_order': 23,
      },
      {
        'icon': '🫀',
        'title': 'Heart Beats',
        'content':
            'Your heart beats about 100,000 times per day, pumping approximately 2,000 gallons of blood throughout your body.',
        'category': 'Human Body',
        'sort_order': 24,
      },
      {
        'icon': '🌋',
        'title': 'Volcano Power',
        'content':
            'The energy released by a large volcanic eruption can be equivalent to thousands of atomic bombs.',
        'category': 'Science',
        'sort_order': 25,
      },
      {
        'icon': '🦎',
        'title': 'Chameleon Color',
        'content':
            'Chameleons change color not just for camouflage, but also to communicate emotions, regulate temperature, and attract mates.',
        'category': 'Animals',
        'sort_order': 26,
      },
      {
        'icon': '🌲',
        'title': 'Tree Age',
        'content':
            'The oldest known living tree is over 5,000 years old. It was already ancient when the pyramids were built.',
        'category': 'Nature',
        'sort_order': 27,
      },
      {
        'icon': '💪',
        'title': 'Muscle Power',
        'content':
            'The strongest muscle in the human body relative to its size is the masseter (jaw muscle). It can exert a force of up to 200 pounds.',
        'category': 'Human Body',
        'sort_order': 28,
      },
      {
        'icon': '☀️',
        'title': 'Sun Size',
        'content':
            'The Sun is so large that about 1.3 million Earths could fit inside it. Yet it\'s actually a relatively small star.',
        'category': 'Astronomy',
        'sort_order': 29,
      },
      {
        'icon': '🐜',
        'title': 'Ant Strength',
        'content':
            'Ants can lift objects 10-50 times their own body weight. If humans had the same strength ratio, we could lift cars.',
        'category': 'Animals',
        'sort_order': 30,
      },
    ];
    for (final trivia in triviaList) {
      await db.insert('trivia', trivia);
    }
    final financialGuides = [
      {
        'stage': 'Youth',
        'age_range': '0-18',
        'icon': '👶',
        'border_color': 'pink',
        'description':
            'Cultivate correct financial awareness, learn basic financial knowledge, and lay a good foundation for the future.',
        'advice':
            '["Develop savings habits and establish pocket money management concepts","Learn basic financial knowledge","Participate in family financial decision-making discussions","Understand basic investment concepts"]',
        'sort_order': 1,
      },
      {
        'stage': 'Young Adult',
        'age_range': '18-35',
        'icon': '👨',
        'border_color': 'blue',
        'description':
            'Career starting stage, focus on income accumulation and risk protection, start diversified investment.',
        'advice':
            '["Establish emergency fund (6 months of expenses)","Configure accident and medical insurance","Start fund investment, cultivate investment habits","Plan career development, improve income ability","Prepare for home purchase down payment, pay attention to mortgage policies"]',
        'sort_order': 2,
      },
      {
        'stage': 'Middle Age',
        'age_range': '35-60',
        'icon': '👨‍💼',
        'border_color': 'green',
        'description':
            'Career growth period, stable income, need to balance family expenses and investment.',
        'advice':
            '["Improve family protection system, configure critical illness insurance","Plan children\'s education fund","Increase investment asset allocation","Consider pension plans","Appropriately allocate real estate investment"]',
        'sort_order': 3,
      },
      {
        'stage': 'Senior',
        'age_range': '60+',
        'icon': '👴',
        'border_color': 'yellow',
        'description':
            'Retirement stage, focus on asset preservation and stable returns, reasonably plan pension withdrawal.',
        'advice':
            '["Configure pension annuity insurance","Reasonably arrange pension withdrawal plan","Reduce investment risk, ensure fund safety","Plan estate inheritance plan","Pay attention to medical and health expenses"]',
        'sort_order': 4,
      },
    ];
    for (final guide in financialGuides) {
      final guideId = await db.insert('financial_guide', guide);
      List<Map<String, dynamic>> allocations = [];
      if (guide['stage'] == 'Youth') {
        allocations = [
          {
            'guide_id': guideId,
            'investment_type': 'Savings',
            'percentage': 80,
            'sort_order': 1,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Education Fund',
            'percentage': 20,
            'sort_order': 2,
          },
        ];
      } else if (guide['stage'] == 'Young Adult') {
        allocations = [
          {
            'guide_id': guideId,
            'investment_type': 'Savings',
            'percentage': 30,
            'sort_order': 1,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Insurance',
            'percentage': 20,
            'sort_order': 2,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Fund Investment',
            'percentage': 40,
            'sort_order': 3,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Other Investments',
            'percentage': 10,
            'sort_order': 4,
          },
        ];
      } else if (guide['stage'] == 'Middle Age') {
        allocations = [
          {
            'guide_id': guideId,
            'investment_type': 'Stable Investment',
            'percentage': 40,
            'sort_order': 1,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Insurance',
            'percentage': 15,
            'sort_order': 2,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Stock Funds',
            'percentage': 25,
            'sort_order': 3,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Real Estate',
            'percentage': 20,
            'sort_order': 4,
          },
        ];
      } else if (guide['stage'] == 'Senior') {
        allocations = [
          {
            'guide_id': guideId,
            'investment_type': 'Fixed Income',
            'percentage': 60,
            'sort_order': 1,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Pension Insurance',
            'percentage': 20,
            'sort_order': 2,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Stable Funds',
            'percentage': 15,
            'sort_order': 3,
          },
          {
            'guide_id': guideId,
            'investment_type': 'Cash Reserve',
            'percentage': 5,
            'sort_order': 4,
          },
        ];
      }
      for (final allocation in allocations) {
        await db.insert('financial_guide_allocation', allocation);
      }
    }
  }

  Future<MonopolyGameProgress?> getMonopolyGameProgress() async {
    try {
      final db = await database;
      final maps = await db.query('monopoly_game_progress', limit: 1);
      if (maps.isEmpty) return null;
      return MonopolyGameProgress.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateMonopolyGameProgress(MonopolyGameProgress progress) async {
    try {
      final db = await database;
      return await db.update(
        'monopoly_game_progress',
        progress.toMap(),
        where: 'id = ?',
        whereArgs: [progress.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> resetMonopolyGameProgress() async {
    try {
      final db = await database;
      final progress = await getMonopolyGameProgress();
      if (progress == null) return 0;
      return await db.update(
        'monopoly_game_progress',
        {
          'current_position': 1,
          'current_guess_count': 0,
          'current_attempt_count': 0,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [progress.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<WaterChallengeProfile?> getWaterChallengeProfile() async {
    try {
      final db = await database;
      final maps = await db.query('water_challenge_profile', limit: 1);
      if (maps.isEmpty) return null;
      return WaterChallengeProfile.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<int> updateWaterChallengeProfile(WaterChallengeProfile profile) async {
    try {
      final db = await database;
      return await db.update(
        'water_challenge_profile',
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [profile.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> insertWaterChallengeHistory(WaterChallengeHistory history) async {
    try {
      final db = await database;
      return await db.insert('water_challenge_history', history.toMap());
    } catch (e) {
      return 0;
    }
  }

  Future<List<WaterChallengeHistory>> getWaterChallengeHistory({
    int limit = 100,
  }) async {
    try {
      final db = await database;
      final maps = await db.query(
        'water_challenge_history',
        orderBy: 'created_at DESC, id DESC',
        limit: limit,
      );
      return maps.map((map) => WaterChallengeHistory.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<WaterChallengeHistory>> getSuccessHistory({
    int limit = 100,
  }) async {
    try {
      final db = await database;
      final maps = await db.query(
        'water_challenge_history',
        where: 'is_success = ?',
        whereArgs: [1],
        orderBy: 'created_at DESC, id DESC',
        limit: limit,
      );
      return maps.map((map) => WaterChallengeHistory.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<WaterChallengeHistory>> getFailureHistory({
    int limit = 100,
  }) async {
    try {
      final db = await database;
      final maps = await db.query(
        'water_challenge_history',
        where: 'is_success = ?',
        whereArgs: [0],
        orderBy: 'created_at DESC, id DESC',
        limit: limit,
      );
      return maps.map((map) => WaterChallengeHistory.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<WaterChallengeAchievement>> getAchievements() async {
    try {
      final db = await database;
      final maps = await db.query('water_challenge_achievement');
      return maps.map((map) => WaterChallengeAchievement.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> updateAchievement(WaterChallengeAchievement achievement) async {
    try {
      final db = await database;
      return await db.update(
        'water_challenge_achievement',
        achievement.toMap(),
        where: 'id = ?',
        whereArgs: [achievement.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> unlockAchievement(String achievementKey) async {
    try {
      final db = await database;
      return await db.update(
        'water_challenge_achievement',
        {'is_achieved': 1, 'achieved_at': DateTime.now().toIso8601String()},
        where: 'achievement_key = ? AND is_achieved = ?',
        whereArgs: [achievementKey, 0],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<List<Trivia>> getAllTrivia() async {
    try {
      final db = await database;
      final maps = await db.query('trivia', orderBy: 'sort_order ASC, id ASC');
      return maps.map((map) => Trivia.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Trivia>> getTriviaByCategory(String category) async {
    try {
      final db = await database;
      final maps = await db.query(
        'trivia',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'sort_order ASC, id ASC',
      );
      return maps.map((map) => Trivia.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Trivia>> getUnreadTrivia() async {
    try {
      final db = await database;
      final maps = await db.rawQuery('''
        SELECT * FROM trivia
        WHERE id NOT IN (SELECT trivia_id FROM trivia_read_history)
        ORDER BY sort_order ASC, id ASC
      ''');
      return maps.map((map) => Trivia.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> markTriviaAsRead(int triviaId) async {
    try {
      final db = await database;
      final existing = await db.query(
        'trivia_read_history',
        where: 'trivia_id = ?',
        whereArgs: [triviaId],
      );
      if (existing.isNotEmpty) return 0;
      return await db.insert('trivia_read_history', {
        'trivia_id': triviaId,
        'read_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return 0;
    }
  }

  Future<int> getReadTriviaCount() async {
    try {
      final db = await database;
      final result = await db.rawQuery(
        'SELECT COUNT(DISTINCT trivia_id) as count FROM trivia_read_history',
      );
      return result.first['count'] as int;
    } catch (e) {
      return 0;
    }
  }

  Future<int> favoritTrivia(int triviaId) async {
    try {
      final db = await database;
      return await db.insert('trivia_favorite', {
        'trivia_id': triviaId,
        'favorited_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      return 0;
    }
  }

  Future<int> unfavoritTrivia(int triviaId) async {
    try {
      final db = await database;
      return await db.delete(
        'trivia_favorite',
        where: 'trivia_id = ?',
        whereArgs: [triviaId],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<List<Trivia>> getFavoritedTrivia() async {
    try {
      final db = await database;
      final maps = await db.rawQuery('''
        SELECT t.* FROM trivia t
        INNER JOIN trivia_favorite f ON t.id = f.trivia_id
        ORDER BY f.favorited_at DESC, f.id DESC
      ''');
      return maps.map((map) => Trivia.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> isTriviaFavorited(int triviaId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'trivia_favorite',
        where: 'trivia_id = ?',
        whereArgs: [triviaId],
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<List<FinancialGuide>> getAllFinancialGuides() async {
    try {
      final db = await database;
      final maps = await db.query(
        'financial_guide',
        orderBy: 'sort_order ASC, id ASC',
      );
      return maps.map((map) => FinancialGuide.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<FinancialGuide?> getFinancialGuideByStage(String stage) async {
    try {
      final db = await database;
      final maps = await db.query(
        'financial_guide',
        where: 'stage = ?',
        whereArgs: [stage],
        limit: 1,
      );
      if (maps.isEmpty) return null;
      return FinancialGuide.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<List<FinancialGuideAllocation>> getFinancialGuideAllocations(
    int guideId,
  ) async {
    try {
      final db = await database;
      final maps = await db.query(
        'financial_guide_allocation',
        where: 'guide_id = ?',
        whereArgs: [guideId],
        orderBy: 'sort_order ASC, id ASC',
      );
      return maps.map((map) => FinancialGuideAllocation.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteAllData() async {
    try {
      final db = await database;
      await db.delete('monopoly_game_progress');
      await db.delete('water_challenge_profile');
      await db.delete('water_challenge_history');
      await db.delete('water_challenge_achievement');
      await db.delete('trivia_read_history');
      await db.delete('trivia_favorite');
      await _initializeDefaultData(db);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DailyTask>> getTodayTasks() async {
    try {
      final db = await database;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final maps = await db.query(
        'daily_tasks',
        where: 'task_date = ?',
        whereArgs: [today],
      );
      return maps.map((map) => DailyTask.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> generateDailyTasks() async {
    try {
      final db = await database;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final existing = await getTodayTasks();
      if (existing.isNotEmpty) {
        return;
      }
      final taskTemplates = [
        {
          'task_key': 'monopoly_guess_5',
          'title': 'Guess 5 Times',
          'description': 'Correctly guess water volume 5 times in Monopoly',
          'target_value': 5,
          'reward_coins': 30,
        },
        {
          'task_key': 'challenge_win_3',
          'title': 'Win 3 Challenges',
          'description': 'Successfully complete 3 water challenges',
          'target_value': 3,
          'reward_coins': 40,
        },
        {
          'task_key': 'trivia_read_5',
          'title': 'Learn 5 Facts',
          'description': 'Read 5 trivia articles',
          'target_value': 5,
          'reward_coins': 25,
        },
        {
          'task_key': 'quiz_answer_3',
          'title': 'Answer 3 Quizzes',
          'description': 'Answer 3 quiz questions correctly',
          'target_value': 3,
          'reward_coins': 35,
        },
        {
          'task_key': 'savings_add',
          'title': 'Save Money',
          'description': 'Add funds to any savings goal',
          'target_value': 1,
          'reward_coins': 20,
        },
      ];
      taskTemplates.shuffle();
      final selectedTasks = taskTemplates.take(3);
      for (final template in selectedTasks) {
        final result = await db.insert('daily_tasks', {
          'task_key': template['task_key'],
          'title': template['title'],
          'description': template['description'],
          'target_value': template['target_value'],
          'current_value': 0,
          'reward_coins': template['reward_coins'],
          'is_completed': 0,
          'task_date': today,
          'created_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {}
  }

  Future<int> updateTaskProgress(int taskId, int progress) async {
    try {
      final db = await database;
      return await db.update(
        'daily_tasks',
        {'current_value': progress},
        where: 'id = ?',
        whereArgs: [taskId],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<void> updateDailyTaskProgress(String taskKey, int progress) async {
    try {
      final db = await database;
      final today = DateTime.now().toIso8601String().split('T')[0];
      final tasks = await db.query(
        'daily_tasks',
        where: 'task_key = ? AND task_date = ? AND is_completed = 0',
        whereArgs: [taskKey, today],
      );
      if (tasks.isEmpty) return;
      final task = DailyTask.fromMap(tasks.first);
      await db.update(
        'daily_tasks',
        {'current_value': progress},
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (progress >= task.targetValue && !task.isCompleted) {
        await completeTask(task.id!);
      }
    } catch (e) {}
  }

  Future<bool> completeTask(int taskId) async {
    try {
      final db = await database;
      final result = await db.update(
        'daily_tasks',
        {'is_completed': 1},
        where: 'id = ?',
        whereArgs: [taskId],
      );
      if (result > 0) {
        final task = await db.query(
          'daily_tasks',
          where: 'id = ?',
          whereArgs: [taskId],
        );
        if (task.isNotEmpty) {
          final coins = task.first['reward_coins'] as int;
          await addCoins(coins, 'task', 'Completed daily task');
        }
      }
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  Future<int> createSavingsGoal(SavingsGoal goal) async {
    try {
      final db = await database;
      return await db.insert('savings_goals', goal.toMap());
    } catch (e) {
      return 0;
    }
  }

  Future<List<SavingsGoal>> getAllSavingsGoals() async {
    try {
      final db = await database;
      final maps = await db.query(
        'savings_goals',
        orderBy: 'is_completed ASC, created_at DESC',
      );
      return maps.map((map) => SavingsGoal.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> updateSavingsGoal(SavingsGoal goal) async {
    try {
      final db = await database;
      return await db.update(
        'savings_goals',
        goal.toMap(),
        where: 'id = ?',
        whereArgs: [goal.id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<bool> depositToGoal(int goalId, double amount, String? note) async {
    try {
      final db = await database;
      await db.insert('savings_records', {
        'goal_id': goalId,
        'amount': amount,
        'type': 'deposit',
        'note': note,
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.rawUpdate(
        'UPDATE savings_goals SET current_amount = current_amount + ? WHERE id = ?',
        [amount, goalId],
      );
      final goals = await db.query(
        'savings_goals',
        where: 'id = ?',
        whereArgs: [goalId],
      );
      if (goals.isNotEmpty) {
        final goal = SavingsGoal.fromMap(goals.first);
        if (goal.currentAmount >= goal.targetAmount && !goal.isCompleted) {
          await db.update(
            'savings_goals',
            {
              'is_completed': 1,
              'completed_at': DateTime.now().toIso8601String(),
            },
            where: 'id = ?',
            whereArgs: [goalId],
          );
        }
      }
      await updateDailyTaskProgress('savings_add', 1);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<SavingsRecord>> getSavingsRecords(int goalId) async {
    try {
      final db = await database;
      final maps = await db.query(
        'savings_records',
        where: 'goal_id = ?',
        whereArgs: [goalId],
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => SavingsRecord.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<TriviaQuestion?> getRandomQuestion() async {
    try {
      final db = await database;
      final maps = await db.rawQuery('''
        SELECT * FROM trivia_questions
        ORDER BY RANDOM()
        LIMIT 1
      ''');
      if (maps.isEmpty) return null;
      return TriviaQuestion.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<TriviaQuestion?> getUnansweredQuestion() async {
    try {
      final db = await database;
      final maps = await db.rawQuery('''
        SELECT * FROM trivia_questions
        WHERE id NOT IN (SELECT question_id FROM quiz_history)
        ORDER BY RANDOM()
        LIMIT 1
      ''');
      if (maps.isEmpty) return null;
      return TriviaQuestion.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }

  Future<bool> submitAnswer(
    int questionId,
    int selectedOption,
    bool isCorrect,
  ) async {
    try {
      final db = await database;
      final coinsEarned = isCorrect ? 10 : 0;
      await db.insert('quiz_history', {
        'question_id': questionId,
        'selected_option': selectedOption,
        'is_correct': isCorrect ? 1 : 0,
        'coins_earned': coinsEarned,
        'created_at': DateTime.now().toIso8601String(),
      });
      if (isCorrect) {
        await addCoins(coinsEarned, 'quiz', 'Correct answer');
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, int>> getQuizStats() async {
    try {
      final db = await database;
      final result = await db.rawQuery('''
        SELECT
          COUNT(*) as total,
          SUM(CASE WHEN is_correct = 1 THEN 1 ELSE 0 END) as correct
        FROM quiz_history
      ''');
      if (result.isEmpty) {
        return {'total': 0, 'correct': 0};
      }
      return {
        'total': result.first['total'] as int,
        'correct': result.first['correct'] as int,
      };
    } catch (e) {
      return {'total': 0, 'correct': 0};
    }
  }

  Future<int> getCoinsBalance() async {
    try {
      final db = await database;
      final maps = await db.query('user_coins', limit: 1);
      if (maps.isEmpty) {
        await db.insert('user_coins', {
          'total_coins': 0,
          'updated_at': DateTime.now().toIso8601String(),
        });
        return 0;
      }
      return maps.first['total_coins'] as int;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> addCoins(int amount, String source, String? description) async {
    try {
      final db = await database;
      await db.insert('coins_records', {
        'amount': amount,
        'source': source,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.rawUpdate(
        'UPDATE user_coins SET total_coins = total_coins + ?, updated_at = ?',
        [amount, DateTime.now().toIso8601String()],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deductCoins(
    int amount,
    String source,
    String? description,
  ) async {
    try {
      final db = await database;
      final balance = await getCoinsBalance();
      if (balance < amount) return false;
      await db.insert('coins_records', {
        'amount': -amount,
        'source': source,
        'description': description,
        'created_at': DateTime.now().toIso8601String(),
      });
      await db.rawUpdate(
        'UPDATE user_coins SET total_coins = total_coins - ?, updated_at = ?',
        [amount, DateTime.now().toIso8601String()],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<CoinsRecord>> getCoinsRecords({int limit = 100}) async {
    try {
      final db = await database;
      final maps = await db.query(
        'coins_records',
        orderBy: 'created_at DESC',
        limit: limit,
      );
      return maps.map((map) => CoinsRecord.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<GlobalAchievement>> getAllAchievements() async {
    try {
      final db = await database;
      final maps = await db.query('global_achievements');
      return maps.map((map) => GlobalAchievement.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<GlobalAchievement>> getAchievementsByCategory(
    String category,
  ) async {
    try {
      final db = await database;
      final maps = await db.query(
        'global_achievements',
        where: 'category = ?',
        whereArgs: [category],
      );
      return maps.map((map) => GlobalAchievement.fromMap(map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> unlockGlobalAchievement(String achievementKey) async {
    try {
      final db = await database;
      final existing = await db.query(
        'global_achievements',
        where: 'achievement_key = ? AND is_achieved = ?',
        whereArgs: [achievementKey, 1],
      );
      if (existing.isNotEmpty) return false;
      final result = await db.update(
        'global_achievements',
        {'is_achieved': 1, 'achieved_at': DateTime.now().toIso8601String()},
        where: 'achievement_key = ?',
        whereArgs: [achievementKey],
      );
      if (result > 0) {
        final achievement = await db.query(
          'global_achievements',
          where: 'achievement_key = ?',
          whereArgs: [achievementKey],
        );
        if (achievement.isNotEmpty) {
          final coins = achievement.first['reward_coins'] as int;
          if (coins > 0) {
            await addCoins(coins, 'achievement', 'Unlocked: $achievementKey');
          }
        }
      }
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  Future<void> checkAndUnlockAchievements() async {
    try {
      await _checkMonopolyAchievements();
      await _checkChallengeAchievements();
      await _checkTriviaAchievements();
      await _checkSavingsAchievements();
      await _checkGlobalAchievements();
    } catch (e) {}
  }

  Future<void> _checkMonopolyAchievements() async {
    final progress = await getMonopolyGameProgress();
    if (progress != null) {
      if (progress.totalWins >= 1) {
        await unlockGlobalAchievement('monopoly_first_win');
      }
      if (progress.totalWins >= 10) {
        await unlockGlobalAchievement('monopoly_win_10');
      }
      if (progress.bestRecord > 0 && progress.bestRecord <= 15) {
        await unlockGlobalAchievement('monopoly_perfect_game');
      }
    }
  }

  Future<void> _checkChallengeAchievements() async {
    final profile = await getWaterChallengeProfile();
    if (profile != null) {
      if (profile.totalSuccess >= 1) {
        await unlockGlobalAchievement('challenge_first_success');
      }
      if (profile.level >= 10) {
        await unlockGlobalAchievement('challenge_level_10');
      }
      if (profile.consecutiveWins >= 10) {
        await unlockGlobalAchievement('challenge_streak_10');
      }
    }
    final db = await database;
    final perfect = await db.query(
      'water_challenge_history',
      where: 'error_amount = 0 AND is_success = 1',
      limit: 1,
    );
    if (perfect.isNotEmpty) {
      await unlockGlobalAchievement('challenge_perfect_shot');
    }
  }

  Future<void> _checkTriviaAchievements() async {
    final totalCount = await database.then(
      (d) => d.rawQuery('SELECT COUNT(*) as count FROM trivia'),
    );
    final readCount = await getReadTriviaCount();
    if (totalCount.isNotEmpty &&
        readCount == totalCount.first['count'] as int) {
      await unlockGlobalAchievement('trivia_read_all');
    }
    final quizStats = await getQuizStats();
    if (quizStats['correct']! >= 50) {
      await unlockGlobalAchievement('quiz_master');
    }
    final db = await database;
    final recent = await db.query(
      'quiz_history',
      orderBy: 'created_at DESC',
      limit: 10,
    );
    if (recent.length >= 10 && recent.every((r) => r['is_correct'] == 1)) {
      await unlockGlobalAchievement('quiz_perfect_score');
    }
  }

  Future<void> _checkSavingsAchievements() async {
    final db = await database;
    final completed = await db.query(
      'savings_goals',
      where: 'is_completed = 1',
    );
    if (completed.length >= 1) {
      await unlockGlobalAchievement('savings_first_goal');
    }
    if (completed.length >= 5) {
      await unlockGlobalAchievement('savings_goal_5');
    }
    final total = await db.rawQuery(
      'SELECT SUM(current_amount) as total FROM savings_goals',
    );
    if (total.isNotEmpty && ((total.first['total'] as double?) ?? 0) >= 1000) {
      await unlockGlobalAchievement('savings_1000');
    }
  }

  Future<void> _checkGlobalAchievements() async {
    final db = await database;
    final tasks = await db.rawQuery('''
      SELECT task_date, COUNT(*) as completed_count
      FROM daily_tasks
      WHERE is_completed = 1
      GROUP BY task_date
      ORDER BY task_date DESC
      LIMIT 7
    ''');
    if (tasks.length >= 7) {
      await unlockGlobalAchievement('daily_tasks_7');
    }
    final coins = await getCoinsBalance();
    if (coins >= 1000) {
      await unlockGlobalAchievement('coins_collector');
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
