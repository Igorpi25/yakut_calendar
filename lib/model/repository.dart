abstract class ArticleRepository{
  Future<String> getArticleFor(DateTime date);
  Future<String> getSummaryFor(DateTime date);
  Future<String> getAdFor(DateTime date);
}