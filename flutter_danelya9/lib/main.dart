import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_danelya9/bloc/bloc_bloc.dart';
import 'package:flutter_danelya9/bloc/bloc_state.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(),
      child: MaterialApp(
        title: 'Fetch Posts Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    PostsScreen(),
    WorkScreen(),
    ProfileScreen(),
    CannerApp(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PostCubit>(context).fetchPosts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lab9'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Work',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.casino),
            label: 'Dice',
            backgroundColor: Colors.red,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postBloc = BlocProvider.of<PostCubit>(context);
    postBloc.fetchPosts();

    return BlocConsumer<PostCubit, PostState>(
      listener: (context, state) {
        if (state is PostError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is PostLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          return ListView.builder(
            itemCount: state.posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.posts[index].title),
                subtitle: Text('UserId: ${state.posts[index].userId}\n'
                    'Id: ${state.posts[index].id}\n'
                    '${state.posts[index].body}'),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}

class WorkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/profileanimation.json'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/workanimation.json'),
    );
  }
}

class CannerApp extends StatefulWidget {
  @override
  _CannerApp createState() => _CannerApp();
}

class _CannerApp extends State<CannerApp> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  CameraFacing cameraFacing = CameraFacing.back;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('QR Scanner'),
          actions: [
            IconButton(
              icon: Icon(Icons.switch_camera),
              onPressed: _toggleCamera,
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 250,
                ),
                cameraFacing: cameraFacing,
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: (result != null)
                    ? Text('Data: ${result!.code}')
                    : Text('Scan a QR code'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _toggleCamera() {
    if (cameraFacing == CameraFacing.back) {
      cameraFacing = CameraFacing.front;
    } else {
      cameraFacing = CameraFacing.back;
    }
    controller?.flipCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
