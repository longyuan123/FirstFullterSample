import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

/**
 * Stateless widgets 是不可变的, 这意味着它们的属性不能改变 - 所有的值都是最终的.
    Stateful widgets 持有的状态可能在widget生命周期中发生变化. 实现一个 stateful widget 至少需要两个类:
    一个 StatefulWidget类。
    一个 State类。 StatefulWidget类本身是不变的，但是 State类在widget生命周期中始终存在.
 */
class MyAppNotUsed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
        ),
        body: new Center(
          //child: new Text('Hello World'),
          //“驼峰命名法” :, 表示字符串中的每个单词（包括第一个单词）都以大写字母开头。
          //child: new Text(wordPair.asPascalCase)
          child: new RandomWords(),
        ),
      ),
    );
  }
}
//您可以通过配置ThemeData类轻松更改应用程序的主题。
// 您的应用程序目前使用默认主题，下面将更改primary color颜色为白色。
class MyApp extends StatelessWidget {
  Widget build(BuildContext context){
    return new MaterialApp(
      title: "Startup Name Generator",
      theme: new ThemeData(
        primaryColor: Colors.blue
      ),
      home:new RandomWords()
    );
  }
}
class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
   // final wordPair = new WordPair.random();
    //return new Text(wordPair.asPascalCase);
    //更新RandomWordsState的build方法以使用_buildSuggestions()
    // 不是直接调用单词生成库
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("StartUp Name Generator"),
        //AppBar添加一个列表图标。当用户点击列表图标时，包含收藏夹的新路由页面入栈显示
        actions:<Widget>[new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)]
      ),
      body:_buildSuggestions()
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      //新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数
    //添加Navigator.push调用，这会使路由入栈（以后路由入栈均指推入到导航管理器的栈）
      new MaterialPageRoute(
            builder: (context) {
              final tiles = _saved.map(
                      (pair) {
                    return new ListTile(
                      title: new Text(
                        pair.asPascalCase,
                        style: _biggerFont,
                      ),
                    );
                  });
              final divided = ListTile.divideTiles(
                  context: context,
                  tiles: tiles
              ).toList();
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text("Saved Suggestions"),

                ),
                  body: new ListView(children: divided)
              );
            }
          )

        );

  }
  //向RandomWordsState类添加一个 _buildSuggestions() 函数.
  // 此方法构建显示建议单词对的ListView
  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该函数会添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          if(i>100) return null;
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();
// 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对

          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style:_biggerFont,
      ),
      trailing: new Icon(
        alreadySaved?Icons.favorite:Icons.favorite_border,
        color: alreadySaved?Colors.red:null,
      ),
      //当心形❤️图标被点击时，函数调用setState()通知框架状态已经改变。
      //在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      },
    );
  }
}
