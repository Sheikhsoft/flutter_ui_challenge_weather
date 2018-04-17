import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:spritewidget/spritewidget.dart';

// The image map hold all of our image assets.
ImageMap _images;

// The sprite sheet contains an image and a set of rectangles defining the
// individual sprites.
SpriteSheet _sprites;

class RainScreen extends StatefulWidget {
  @override
  _RainScreenState createState() => new _RainScreenState();
}

class _RainScreenState extends State<RainScreen> {

  // This method loads all assets that are needed for the demo.
  Future<Null> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/weathersprites.png',
    ]);

    // Load the sprite sheet, which contains snowflakes and rain drops.
    String json = await DefaultAssetBundle.of(context).loadString('assets/weathersprites.json');
    _sprites = new SpriteSheet(_images['assets/weathersprites.png'], json);
  }

  @override
  void initState() {
    // Always call super.initState
    super.initState();

    // Get our root asset bundle
    AssetBundle bundle = rootBundle;

    // Load all graphics, then set the state to assetsLoaded and create the
    // WeatherWorld sprite tree
    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = new WeatherWorld();
      });
    });
  }

  bool assetsLoaded = false;

  // The weather world is our sprite tree that handles the weather
  // animations.
  WeatherWorld weatherWorld;

  @override
  Widget build(BuildContext context) {
    // Until assets are loaded we are just displaying a blue screen.
    // If we were to load many more images, we might want to do some
    // loading animation here.
    if (!assetsLoaded) {
      return new Container();
    }

    // All assets are loaded, build the whole app with weather buttons
    // and the WeatherWorld.
    return new SpriteWidget(weatherWorld);
  }
}

// The WeatherWorld is our root node for our sprite tree. The size of the tree
// will be scaled to fit into our SpriteWidget container.
class WeatherWorld extends NodeWithSize {
  Rain _rain;

  WeatherWorld() : super(const Size(2048.0, 2048.0)) {
    _rain = new Rain();
    _rain.active = true;
    addChild(_rain);
  }
}

// Rain layer. Uses three layers of particle systems, to create a parallax
// rain effect.
class Rain extends Node {
  Rain() {
    _addParticles(1.0);
    _addParticles(1.5);
    _addParticles(2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(double distance) {
    ParticleSystem particles = new ParticleSystem(
        _sprites['raindrop.png'],
        transferMode: BlendMode.lighten,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 10000.0 / distance,
        speedVar: 100.0 / distance,
        startSize: 1.2 / distance,
        startSizeVar: 0.2 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 1.5 * distance,
        lifeVar: 1.0 * distance,
        maxParticles: 15,
    );
    particles.position = const Offset(1024.0, -200.0);
    particles.rotation = 0.0;
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    actions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        actions.run(
            new ActionTween<double>(
                    (a) => system.opacity = a,
                system.opacity,
                1.0,
                2.0
            ));
      } else {
        actions.run(
            new ActionTween<double>(
                    (a) => system.opacity = a,
                system.opacity,
                0.0,
                0.5
            ));
      }
    }
  }
}