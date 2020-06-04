import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;

final _uRLNEWS = 'https://newsapi.org/v2';
final _aPIKEY = '66ff404e52194c4abe75d98195bac41d';

class NewsService with ChangeNotifier {
  List<Article> headlines = [];

  String _selectedCategory = 'business';

  List<Category> categories = [
    Category( FontAwesomeIcons.building, 'business'),
    Category( FontAwesomeIcons.tv, 'entertainment'),
    //Category( FontAwesomeIcons.addressCard, 'general'),
    Category( FontAwesomeIcons.headSideVirus, 'health'),
    Category( FontAwesomeIcons.vials, 'science'),
    Category( FontAwesomeIcons.baseballBall, 'sports'),
    Category( FontAwesomeIcons.memory, 'technology'),
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((item) { 
      this.categoryArticles[item.name] = new List();
    });

    this.getArticlesByCategory( this._selectedCategory );

  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory( String valor ){

    this._selectedCategory = valor;

    this._isLoading = true;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }


  List<Article> get getArticulosCategoriasSeleccionada => this.categoryArticles[ this.selectedCategory ];

  getTopHeadlines() async{

    final url = '$_uRLNEWS/top-headlines?apiKey=$_aPIKEY&country=us';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    this.headlines.addAll( newsResponse.articles );
    notifyListeners();

  }

   bool _isLoading = true;

   bool get isLoading => this._isLoading;

  getArticlesByCategory( String category ) async{

      if ( this.categoryArticles[category].length > 0 ) {
        this._isLoading = false;
        notifyListeners();
        return this.categoryArticles[category];
      }

    final url = '$_uRLNEWS/top-headlines?apiKey=$_aPIKEY&country=us&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson( resp.body );

    this.categoryArticles[category].addAll( newsResponse.articles );

    this._isLoading = false;

    notifyListeners();
  }

}
