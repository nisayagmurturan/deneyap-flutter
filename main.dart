import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const WordQuizApp());
}

class WordQuizApp extends StatelessWidget {
  const WordQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kelime Bilmece',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),
      ),
      home: const QuizPage(),
    );
  }
}

class WordModel {
  final String english;
  final String turkish;
  final IconData icon;

  const WordModel({
    required this.english,
    required this.turkish,
    required this.icon,
  });
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<WordModel> _allWords = [
    const WordModel(
      english: 'adventure',
      turkish: 'macera',
      icon: Icons.explore,
    ),
    const WordModel(
      english: 'celebrate',
      turkish: 'kutlamak',
      icon: Icons.celebration,
    ),
    const WordModel(english: 'environment', turkish: 'çevre', icon: Icons.eco),
    const WordModel(english: 'flight', turkish: 'uçuş', icon: Icons.flight),
    const WordModel(
      english: 'government',
      turkish: 'hükümet',
      icon: Icons.account_balance,
    ),
    const WordModel(
      english: 'healthy',
      turkish: 'sağlıklı',
      icon: Icons.health_and_safety,
    ),
    const WordModel(
      english: 'imagine',
      turkish: 'hayal etmek',
      icon: Icons.auto_awesome,
    ),
    const WordModel(english: 'journey', turkish: 'yolculuk', icon: Icons.map),
    const WordModel(
      english: 'knowledge',
      turkish: 'bilgi',
      icon: Icons.local_library,
    ),
    const WordModel(english: 'language', turkish: 'dil', icon: Icons.translate),
    const WordModel(english: 'protect', turkish: 'korumak', icon: Icons.shield),
    const WordModel(english: 'science', turkish: 'bilim', icon: Icons.science),
    const WordModel(
      english: 'temperature',
      turkish: 'sıcaklık',
      icon: Icons.thermostat,
    ),
    const WordModel(
      english: 'vacation',
      turkish: 'tatil',
      icon: Icons.beach_access,
    ),
    const WordModel(
      english: 'weather',
      turkish: 'hava durumu',
      icon: Icons.cloud,
    ),
    const WordModel(english: 'connect', turkish: 'bağlanmak', icon: Icons.link),
    const WordModel(
      english: 'create',
      turkish: 'yaratmak',
      icon: Icons.palette,
    ),
    const WordModel(
      english: 'challenge',
      turkish: 'meydan okuma',
      icon: Icons.emoji_events,
    ),
    const WordModel(
      english: 'accident',
      turkish: 'kaza',
      icon: Icons.car_crash,
    ),
    const WordModel(
      english: 'agree',
      turkish: 'anlaşmak',
      icon: Icons.handshake,
    ),
    const WordModel(
      english: 'baggage',
      turkish: 'bagaj',
      icon: Icons.business_center,
    ),
    const WordModel(
      english: 'customer',
      turkish: 'müşteri',
      icon: Icons.support_agent,
    ),
    const WordModel(
      english: 'frequently',
      turkish: 'sık sık',
      icon: Icons.update,
    ),
    const WordModel(
      english: 'improve',
      turkish: 'geliştirmek',
      icon: Icons.trending_up,
    ),
    const WordModel(
      english: 'schedule',
      turkish: 'program',
      icon: Icons.calendar_month,
    ),
  ];

  int _currentIndex = 0;
  int _correctCount = 0;
  int _wrongCount = 0;
  bool _isFinished = false;

  List<WordModel> _currentOptions = [];
  String? _selectedAnswer;
  bool _hasAnswered = false;

  // Zamanlayıcı Değişkenleri
  Timer? _timer;
  var _remainingSeconds;
  static const int _questionDuration = 15;

  @override
  void initState() {
    super.initState();
    _allWords.shuffle();
    _generateOptions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _questionDuration;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_hasAnswered) return;

    setState(() {
      _hasAnswered = true;
      _wrongCount++;
      _selectedAnswer = ""; // Boş bırakılarak yanlış kabul edilir
    });

    _goToNextQuestion();
  }

  void _generateOptions() {
    if (_currentIndex >= _allWords.length) {
      _timer?.cancel();
      setState(() {
        _isFinished = true;
      });
      return;
    }

    final WordModel correctWord = _allWords[_currentIndex];
    final List<WordModel> options = [correctWord];

    final List<WordModel> wrongWords = _allWords
        .where((w) => w.turkish != correctWord.turkish)
        .toList();

    wrongWords.shuffle();

    // TİP HATASI ÖNLEME: math.min yerine manuel kontrol ile int güvenliği sağlandı
    int wrongCountToAdd = wrongWords.length;
    if (wrongCountToAdd > 3) {
      wrongCountToAdd = 3;
    }

    for (int i = 0; i < wrongCountToAdd; i++) {
      options.add(wrongWords[i]);
    }

    options.shuffle();

    setState(() {
      _currentOptions = options;
      _selectedAnswer = null;
      _hasAnswered = false;
    });

    _startTimer();
  }

  void _checkAnswer(WordModel selectedWord) {
    if (_hasAnswered) return;

    _timer?.cancel();
    final String correctAnswer = _allWords[_currentIndex].turkish;

    setState(() {
      _hasAnswered = true;
      _selectedAnswer = selectedWord.turkish;

      if (selectedWord.turkish == correctAnswer) {
        _correctCount++;
      } else {
        _wrongCount++;
      }
    });

    _goToNextQuestion();
  }

  void _goToNextQuestion() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _generateOptions();
      });
    });
  }

  void _resetQuiz() {
    setState(() {
      _allWords.shuffle();
      _currentIndex = 0;
      _correctCount = 0;
      _wrongCount = 0;
      _isFinished = false;
      _generateOptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelime Ezberle v3.4',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isFinished ? _buildResultScreen() : _buildQuizScreen(),
        ),
      ),
    );
  }

  Widget _buildQuizScreen() {
    if (_currentIndex >= _allWords.length) return const SizedBox.shrink();

    final currentWord = _allWords[_currentIndex];
    final progress = _currentIndex / _allWords.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWideScreen = constraints.maxWidth > 600;
        final int crossAxisCount = isWideScreen ? 4 : 2;
        final double childAspectRatio = isWideScreen ? 1.2 : 1.1;

        return Column(
          children: [
            // İlerleme Çubuğu
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.indigo.withOpacity(0.1),
                color: Colors
                    .indigo, // TİP HATASI ÖNLEME: valueColor yerine doğrudan color kullanıldı
              ),
            ),
            const SizedBox(height: 12),

            // Süre Sayacı & Skor Alanı
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildScoreCard('Doğru', _correctCount, Colors.green),
                _buildTimerIndicator(),
                _buildScoreCard('Yanlış', _wrongCount, Colors.red),
              ],
            ),
            const SizedBox(height: 16),

            // Soru Alanı
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${_currentIndex + 1} / ${_allWords.length}',
                        style: TextStyle(
                          color: Colors.indigo.withOpacity(0.6),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        currentWord.english,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w800,
                          color: Colors.indigo,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'kelimesinin Türkçe karşılığı nedir?',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Duyarlı Izgara Şık Alanı
            Expanded(
              flex: 6,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: _currentOptions.length,
                itemBuilder: (context, index) {
                  final option = _currentOptions[index];
                  return _buildGridOptionButton(option);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimerIndicator() {
    final double timerProgress = _remainingSeconds / _questionDuration;
    final Color timerColor = _remainingSeconds <= 3
        ? Colors.red
        : Colors.orange;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 42,
          height: 42,
          child: CircularProgressIndicator(
            value: timerProgress,
            strokeWidth: 4,
            backgroundColor: Colors.grey.withOpacity(0.2),
            color:
                timerColor, // TİP HATASI ÖNLEME: valueColor yerine doğrudan color kullanıldı
          ),
        ),
        Text(
          '$_remainingSeconds',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: timerColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGridOptionButton(WordModel option) {
    if (_currentIndex >= _allWords.length) return const SizedBox.shrink();

    final String correctAnswer = _allWords[_currentIndex].turkish;
    final bool isSelected = _selectedAnswer == option.turkish;

    Color cardColor = Colors.white;
    Color borderColor = Colors.indigo.withOpacity(0.15);
    Color contentColor = Colors.indigo.shade700;
    Color iconBgColor = Colors.indigo.withOpacity(0.08);

    if (_hasAnswered) {
      if (option.turkish == correctAnswer) {
        cardColor = Colors.green.shade50;
        borderColor = Colors.green.shade400;
        contentColor = Colors.green.shade800;
        iconBgColor = Colors.green.shade100;
      } else if (isSelected) {
        cardColor = Colors.red.shade50;
        borderColor = Colors.red.shade400;
        contentColor = Colors.red.shade800;
        iconBgColor = Colors.red.shade100;
      } else {
        contentColor = Colors.grey.shade400;
        borderColor = Colors.grey.shade200;
        iconBgColor = Colors.grey.shade100;
      }
    }

    return GestureDetector(
      onTap: () => _checkAnswer(option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 16.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(option.icon, color: contentColor, size: 32),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    option.turkish,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: contentColor,
                    ),
                  ),
                ],
              ),
            ),
            if (_hasAnswered && option.turkish == correctAnswer)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.check_circle, color: Colors.green, size: 24),
              )
            else if (_hasAnswered && isSelected)
              const Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.cancel, color: Colors.red, size: 24),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Center(
      child: Card(
        elevation: 8,
        shadowColor: Colors.indigo.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events, size: 90, color: Colors.amber),
              const SizedBox(height: 16),
              const Text(
                'Test Tamamlandı!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildResultStat(
                    'Toplam aferin',
                    _correctCount,
                    Colors.green,
                  ),
                  _buildResultStat('Toplam salaklık', _wrongCount, Colors.red),
                ],
              ),
              const SizedBox(height: 35),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                onPressed: _resetQuiz,
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Tekrar Dene',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(String title, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultStat(String title, int count, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        const SizedBox(height: 6),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
