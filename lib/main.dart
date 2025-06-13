import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Breath Hold Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BreathHoldScreen(),
    );
  }
}

class BreathHoldScreen extends StatefulWidget {
  @override
  _BreathHoldScreenState createState() => _BreathHoldScreenState();
}

class _BreathHoldScreenState extends State<BreathHoldScreen>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _isRunning = false;
  bool _hasStarted = false;
  bool _showResult = false;
  double _finalPosition = 0.0;
  String _result = '';
  int _timeInSeconds = 0;

  final List<String> _levels = [
    'inhale',
    'hold your breath',
    'smoke 24/7',
    'sprinter',
    'football player',
    'Military rookie',
    'free diver'
  ];

  final List<int> _levelTimes = [0, 10, 20, 30, 40, 50, 60];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );

    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.linear),
    );

    _animationController!.addListener(() {
      if (_animationController!.value >= 1.0 && _isRunning) {
        _stopTest();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      _isRunning = true;
      _hasStarted = true;
      _showResult = false;
    });
    _animationController!.forward();
  }

  void _stopTest() {
    if (!_isRunning) return;

    _animationController!.stop();
    _finalPosition = _animation!.value;
    _timeInSeconds = (_finalPosition * 60).round();

    setState(() {
      _isRunning = false;
      _showResult = true;
      _result = _getLungTestResult(_timeInSeconds);
    });
  }

  void _resetTest() {
    _animationController!.reset();
    setState(() {
      _isRunning = false;
      _hasStarted = false;
      _showResult = false;
      _finalPosition = 0.0;
      _timeInSeconds = 0;
      _result = '';
    });
  }

  String _getLungTestResult(int seconds) {
    if (seconds < 5) {
      return "Poor lung capacity. Consider consulting a doctor.";
    } else if (seconds < 15) {
      return "Below average lung capacity. Try breathing exercises.";
    } else if (seconds < 30) {
      return "Average lung capacity. Good baseline fitness.";
    } else if (seconds < 45) {
      return "Good lung capacity. You have decent cardiovascular fitness.";
    } else if (seconds < 60) {
      return "Excellent lung capacity! Great cardiovascular health.";
    } else {
      return "Outstanding! Professional athlete level lung capacity.";
    }
  }

  String _getCurrentLevel() {
    double progress = _isRunning ? _animation!.value : _finalPosition;
    int levelIndex = (progress * (_levels.length - 1)).floor();
    return _levels[levelIndex.clamp(0, _levels.length - 1)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Breath Hold Test'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_showResult) ...[
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'Your Result',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time: $_timeInSeconds seconds',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _result,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
            Expanded(
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 600,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 350,
                        height: 580,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 50,
                              top: 40,
                              child: Container(
                                width: 4,
                                height: 500,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            ...List.generate(_levels.length, (index) {
                              double topPosition = 40 + (index * 80.0);
                              return Positioned(
                                left: 5,
                                top: topPosition - 6,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 12,
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.red[600],
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 2,
                                              offset: Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container( // FIXED: replaced Expanded with Container
                                      width: 220, // fixed width to prevent layout errors
                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _levels[index],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            '${_levelTimes[index]}s',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                            if (_hasStarted)
                              AnimatedBuilder(
                                animation: _animation!,
                                builder: (context, child) {
                                  double progress = _isRunning ? _animation!.value : _finalPosition;
                                  double ballPosition = 40 + (progress * 480) - 10;
                                  return Positioned(
                                    left: 44,
                                    top: ballPosition,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: _isRunning ? Colors.green[500] : Colors.orange[500],
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _isRunning ? Colors.green[200]! : Colors.orange[200]!,
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_hasStarted && (_isRunning || _showResult))
              Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.blue[100]!],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Level',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _getCurrentLevel(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _isRunning
                                  ? '${(_animation!.value * 60).round()}s'
                                  : '${_timeInSeconds}s',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 120,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isRunning ? null : _startTest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.grey[400] : Colors.green[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27.5),
                        ),
                        elevation: _isRunning ? 0 : 4,
                        shadowColor: Colors.green[200],
                      ),
                      child: Text(
                        'START',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _isRunning ? _stopTest : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRunning ? Colors.red[600] : Colors.grey[400],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27.5),
                        ),
                        elevation: _isRunning ? 4 : 0,
                        shadowColor: Colors.red[200],
                      ),
                      child: Text(
                        'STOP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_showResult) ...[
              SizedBox(height: 16),
              Container(
                width: 120,
                height: 40,
                child: ElevatedButton(
                  onPressed: _resetTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Try Again',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
