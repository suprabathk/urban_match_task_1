import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:urban_match_task_1/repo_page.dart';
import 'package:urban_match_task_1/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Repository> _repos = [];
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    loadRepos();
  }

  void loadRepos() async {
    setState(() {
      _isFetching = true;
    });
    final repos = await Repository.getRepos();
    setState(() {
      _repos = repos;
      _isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello there!",
                        style: GoogleFonts.playfairDisplay(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      Text(
                        "UrbanMatch",
                        style: GoogleFonts.alice(
                          textStyle: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  const Icon(Icons.person_outline,
                      color: Colors.white, size: 30),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Colors.white54),
              ),
              Text(
                "Your Repositories",
                style: GoogleFonts.playfairDisplay(
                  textStyle: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(child: repoList(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget repoList(BuildContext context) {
    if (_isFetching) {
      return Center(
        child: Container(
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/loading-cube.json',
              width: 200,
              height: 200,
            )),
      );
    } else {
      return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 12),
          itemCount: _repos.length,
          itemBuilder: (BuildContext context, int index) {
            return RepoCard(
              repo: _repos[index],
            );
          });
    }
  }
}

class RepoCard extends StatelessWidget {
  final Repository repo;

  const RepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: ((context) => RepoPage(repo: repo)))),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFD2D4FF),
                blurRadius: 3.0, // soften the shadow
                spreadRadius: 0.5, //extend
              ),
            ],
            color: const Color(0xFFD2D4FF),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  repo.name,
                  style: GoogleFonts.publicSans(
                      textStyle: const TextStyle(fontSize: 22)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    repo.description,
                    style: GoogleFonts.publicSans(
                        textStyle: const TextStyle(fontSize: 12)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        repo.owner,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700),
                      )),
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.remove_red_eye_rounded,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 2),
                                    child: Text("${repo.watchersCount}"),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.fork_right_rounded,
                                    size: 18,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4.0, left: 2),
                                    child: Text(
                                      "${repo.forks}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
