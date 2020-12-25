import 'dart:convert';
import 'package:recipeapp/secret/data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipeapp/models/recipe.dart';
import 'package:recipeapp/views/recipe_view.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //To call API Data
  List<Recipe> recipes = List<Recipe>();

  String ingredient;

  bool loading = false;

  getRecipes() async {
    setState(() {
      loading = true;
    });
    var recipeData = await http.get(
        "https://api.edamam.com/search?q=$ingredient&app_id=$applicationID&app_key=$applicationKeys");

    Map<String, dynamic> jsonData = jsonDecode(recipeData.body);
    print(jsonData);

    jsonData["hits"].forEach((recipeInfo) {
      Recipe recipe = Recipe();

      Map<String, dynamic> recipeInfo2 = recipeInfo["recipe"];
      recipe = Recipe(
        imgUrl: recipeInfo2["image"],
        label: recipeInfo2["label"],
        source: recipeInfo2["source"],
        url: recipeInfo2["url"],
      );
      //recipe = Recipe.fromMap(recipeInfo["recipe"]);
      recipes.add(recipe);
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Recipe App",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        shadowColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What will you cook today?",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 8),
              Text(
                "Just enter ingredients you have and we will show the best recipe for you",
                style: TextStyle(fontSize: 15),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    onChanged: (value) => {ingredient = value},
                    decoration:
                        InputDecoration(hintText: "enter ingredient name"),
                  )),
                  GestureDetector(
                      onTap: () {
                        if (ingredient != "") {
                          recipes = [];
                          getRecipes();
                        }
                      },
                      child: Icon(Icons.search))
                ],
              ),
              loading
                  ? Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : GridView(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0),
                      children: List.generate(recipes.length, (index) {
                        return RecipeTile(
                          imgUrl: recipes[index].imgUrl,
                          label: recipes[index].label,
                          source: recipes[index].source,
                          url: recipes[index].url,
                        );
                      }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

class RecipeTile extends StatelessWidget {
  final String label, source, imgUrl, url;
  RecipeTile({this.url, this.imgUrl, this.label, this.source});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RecipeView(url)));
      },
      child: Container(
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imgUrl)),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    source,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
