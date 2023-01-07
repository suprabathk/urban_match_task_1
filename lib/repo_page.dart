import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:urban_match_task_1/repository.dart';
import 'commit.dart';

class RepoPage extends StatefulWidget {
  final Repository repo;
  const RepoPage({super.key, required this.repo});

  @override
  State<RepoPage> createState() => _RepoPageState();
}

class _RepoPageState extends State<RepoPage> {
  late Commit _commit;
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    loadCommit();
  }

  void loadCommit() async {
    setState(() {
      _isFetching = true;
    });
    final commit = await Commit.getLastestCommit(widget.repo.name);
    setState(() {
      _isFetching = false;
      _commit = commit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: const Color(0xFFD2D4FF),
        body: Padding(
          padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.repo.name,
                    style: GoogleFonts.alice(
                      textStyle: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.repo.description,
                    style: GoogleFonts.playfairDisplay(
                      textStyle: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.repo.htmlUrl,
                    style: GoogleFonts.playfairDisplay(
                      decoration: TextDecoration.underline,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(color: Colors.black54),
              ),
              commitInfo(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget commitInfo(BuildContext context) {
    if (_isFetching) {
      return Expanded(
        child: Container(
            height: double.infinity,
            alignment: Alignment.center,
            child: Lottie.asset(
              'assets/loading-cube.json',
              width: 200,
              height: 200,
            )),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Latest commit:",
            style: GoogleFonts.playfairDisplay(
              textStyle: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "On ${_commit.date.substring(0, _commit.date.indexOf("T"))}",
            style: GoogleFonts.alice(
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "At ${_commit.date.substring(_commit.date.indexOf("T") + 1, _commit.date.indexOf("Z"))}",
            style: GoogleFonts.alice(
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "By ",
                style: GoogleFonts.alice(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                _commit.author,
                style: GoogleFonts.alice(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            _commit.email,
            style: GoogleFonts.alice(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: Colors.black54),
          ),
          Text(
            "Commit message:",
            style: GoogleFonts.alice(
              textStyle: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _commit.message,
            style: GoogleFonts.alice(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w200,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }
  }
}
