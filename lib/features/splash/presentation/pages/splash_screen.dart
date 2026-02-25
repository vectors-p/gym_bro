import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:gym_bro/core/router/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Splitting into independent X and Y scales for Squash & Stretch
  late final Animation<double> _scaleX;
  late final Animation<double> _scaleY;
  late final Animation<double> _translateY;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();

    // Increased slightly to 1500ms so the whole bounce sequence breathes nicely
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 1. Fade: Quick fade-in during the first 20% of the animation
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    // 2. Vertical Translation: The actual physical jump
    _translateY = TweenSequence<double>([
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 15,
      ), // Anticipation pause
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -80.0,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 35, // Jump up
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -80.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 30, // Fall down
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 20,
      ), // Stay on ground to settle
    ]).animate(_controller);

    // 3. X-Axis (Width): Goes thin when jumping, wide when squashing
    _scaleX = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.2,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15, // Pop in & squash wide (preparing to jump)
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 0.7,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35, // Stretch thin as it shoots up
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.7,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // Normalizing while falling
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.9,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5, // SPLAT: instant squash wide upon impact
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.4,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 15, // Wobble and settle back to normal 1.0
      ),
    ]).animate(_controller);

    // 4. Y-Axis (Height): Goes tall when jumping, short when squashing
    _scaleY = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.2,
          end: 0.7,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15, // Pop in & squash short (preparing to jump)
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.7,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 35, // Stretch tall as it shoots up
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.4,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30, // Normalizing while falling
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 0.6,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 5, // SPLAT: instant squash short upon impact
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.6,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 15, // Wobble and settle back to normal 1.0
      ),
    ]).animate(_controller);

    _controller.forward();

    // Pushed to 2500ms so the user sees the final wobble before routing
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.go(AppRouter.home);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF4500);
    return Scaffold(
      backgroundColor: accent,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Opacity(
              opacity: _fade.value,
              child: Transform(
                // CRUCIAL: Set alignment to bottomCenter so the icon squashes against the floor
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..translate(0.0, _translateY.value)
                  ..scale(_scaleX.value, _scaleY.value),
                child: child,
              ),
            );
          },
          child: Image.asset('assets/icon/splash_image.png', width: 120),
        ),
      ),
    );
  }
}
