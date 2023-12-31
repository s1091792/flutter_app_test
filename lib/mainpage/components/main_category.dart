import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test/colors.dart';
import 'package:flutter_app_test/mainpage/foodmanager/foodstitle_with_more_btn.dart';
import 'package:flutter_app_test/mainpage/foodmanager/main_foods_pic.dart';
import 'package:flutter_app_test/mainpage/recipesearch/SelectedListController.dart';
import 'package:get/get.dart';

import '../foodmanager/getFood.dart';
import '../foodmanager/new_food.dart';
import '../recipesearch/title_with_text.dart';
import '../recipesearch/getRecipe.dart';
import 'main_search_header.dart';

class foodmanager extends StatefulWidget {
  const foodmanager({Key? key}) : super(key: key);

  @override
  State<foodmanager> createState() => _foodmanagerState();
}

List<dynamic> allData = []; // 儲存所有抓取到的資料的陣列

class _foodmanagerState extends State<foodmanager> {
  final myController = TextEditingController();
  String text = "尚未接收資料";

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // fetchData(); // 在初始化時開始抓取資料
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: kDefaultPadding,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        //外部間距
                        margin:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        //外部間距
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        width: size.width / 1.4,
                        decoration: BoxDecoration(
                          color: Color(0xFFE9EEF1),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: kPrimaryColor.withOpacity(0.23),
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: myController,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                  hintText: "Search",
                                  hintStyle: TextStyle(
                                    color: kPrimaryColor.withOpacity(0.5),
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  // surffix isn't working properly  with SVG
                                  // thats why we use row
                                  // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon:Image.asset('assets/icons/search.png'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: CircleAvatar(
                            backgroundColor: Colors.grey[200],
                            child: IconButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewFood(),
                                    ),
                                  );
                                  //從 B 畫面回傳後更新畫面資料
                                  setState(() {
                                    print(result);
                                    if (result != null) {
                                      text = result;
                                    } else {
                                      print("新增食材沒有回傳訊息");
                                    }
                                  });
                                },
                                icon: Image.asset('assets/icons/plus.png'))),
                      ),
                    ],
                  ),
                  //foodmanager(),
                ],
              ),
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Column(
              children: <Widget>[
                TitleWithMorebtn(title: "七日內到期", press: () {}),
                getFood7(),
                seven_food_pic(
                  title: commentsData7.map((comment) => comment['title'] as String).toList(),
                  date: commentsData7.map((comment) => comment['date'] as String).toList(),
                  number: commentsData7.map((comment) => comment['number'] as int).toList(),
                  press: () {},
                  image: commentsData7.map((comment) => comment['image'] as String).toList(),
                ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Column(
              children: [
                TitleWithMorebtn(title: "十五日內到期", press: () {}),
                getFood15(),
                seven_food_pic(
                  title: commentsData15.map((comment) => comment['title'] as String).toList(),
                  date: commentsData15.map((comment) => comment['date'] as String).toList(),
                  number: commentsData15.map((comment) => comment['number'] as int).toList(),
                  press: () {},
                  image: commentsData15.map((comment) => comment['image'] as String).toList(),
                ),
              ],
            ),

            //seven_food_pic(),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Column(
              children: [
                TitleWithMorebtn(title: "三十日內到期", press: () {}),
                getFood30(),
                seven_food_pic(
                  title: commentsData30.map((comment) => comment['title'] as String).toList(),
                  date: commentsData30.map((comment) => comment['date'] as String).toList(),
                  number: commentsData30.map((comment) => comment['number'] as int).toList(),
                  press: () {},
                  image: commentsData30.map((comment) => comment['image'] as String).toList(),
                ),
              ],
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Column(
              children: <Widget>[
                TitleWithMorebtn(title: "其餘食材", press: () {}),
                getFood31(),
                seven_food_pic(
                  title: commentsData31.map((comment) => comment['title'] as String).toList(),
                  date: commentsData31.map((comment) => comment['date'] as String).toList(),
                  number: commentsData31.map((comment) => comment['number'] as int).toList(),
                  press: () {},
                  image: commentsData31.map((comment) => comment['image'] as String).toList(),
                )

              ],
            ),
            //seven_food_pic(),
          ],
        ),
      ),
    );
  }
}

//食譜篩選食材用的list
List<String> defaultList = [
  'apple',
  '鳳梨',
  '西瓜',
  '香蕉',
];

class recipesearch extends StatefulWidget {
  const recipesearch({Key? key}) : super(key: key);

  @override
  State<recipesearch> createState() => _recipesearchState();
}

class _recipesearchState extends State<recipesearch> {
  var controller = Get.put(SelectedListController());
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    print("離開食譜查詢");
    super.dispose();
  }
  //此openFilterDialog用來篩選食材
  void openFilterDialog(context) async{
    await FilterListDialog.display<String>(context,
        listData: defaultList,
        selectedListData: controller.getSelectedList(),
        headlineText: '篩選食材',
        //applyButtonText: TextStyle(fontSize: 20),
        choiceChipLabel: (String? item)=> item,
        validateSelectedItem: (list, val)=>list!.contains(val),
        onItemSearch: (list, text){
          return list.toLowerCase().contains(text.toLowerCase());
        },
        onApplyButtonClick: (list){
          setState(() {
            controller.setSelectedList(List<String>.from(list!));
          });
          Navigator.pop(context);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      //外部間距
                      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      //外部間距
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      width: size.width / 1.4,
                      decoration: BoxDecoration(
                        color: Color(0xFFE9EEF1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: kPrimaryColor.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: myController,
                              onChanged: (value) {},
                              decoration: InputDecoration(
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: kPrimaryColor.withOpacity(0.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                // surffix isn't working properly  with SVG
                                // thats why we use row
                                // suffixIcon: SvgPicture.asset("assets/icons/search.svg"),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon:Image.asset('assets/icons/search.png'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          child: IconButton(
                              onPressed: () =>openFilterDialog(context),
                              icon: Image.asset('assets/icons/filter.png'))),
                    ),
                  ],
                ),
                //foodmanager(),
              ],
            ),
          ),

          //controller.getSelectedList()=dialog裡有沒有選東西null就顯示"沒結果"(Center(child: Text('沒有搜尋結果')))or預設食譜
          //有就用 controller.getSelectedList()![index] 取裡面的東西
          controller.getSelectedList() == null || controller.getSelectedList()!.length == 0
              ? Column(
            children: [
              Container(
                width: size.width,
                margin: const EdgeInsets.only(left: kDefaultPadding),
                child: Text(
                  "推薦食譜",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              getRecipe(),
              recipe_title_text(
                size: size,
                title: recipeData.map((recipe) => recipe['title'] as String).toList(),
                text: recipeData.map((recipe) => recipe['text'] as String).toList(),
                imagepath: recipeData.map((recipe) => recipe['imagepath'] as String).toList(),
                step: recipeData.map((recipe) => recipe['step'] as String).toList(),

                press: () {},
                liked: [false,false,false,false],
              ),
            ],
          )
              : recipe_title_text(
            size: size,
            title:
              controller.getSelectedList(),
            text: [
              "蒜頭、培根、蘑菇、鮮奶油、義大利麵、黑胡椒、雞蛋",
              "薑、雞腿肉、剝皮辣椒罐頭、蛤蜊、米酒",
              "玉米、鮮奶、雞蛋、紅蘿蔔",
              "雞翅、菇類、薑、八角、鹽、料理酒、乾香菇、大蔥、乾辣椒、醬油、糖、油",
            ],
            imagepath: [
              "https://i.im.ge/2023/05/14/URFbIT.image.png",
              "https://i.im.ge/2023/05/14/URFE5r.image.png",
              "https://i.im.ge/2023/05/14/URFwEq.image.png",
              "https://i.im.ge/2023/05/14/URFVrJ.image.png",
            ],
            step: [
              "把全部食材丟進鍋裡",
              "把剝皮辣椒罐頭倒進鍋裡",
              "把火腿切成丁",
              "把小雞脫毛",
            ],
            press: () {},
            liked: [false,false,false,false],
          ),
        ],
      ),
    );
  }
}

class shoppinglist extends StatefulWidget {
  const shoppinglist({
    Key? key,
  }) : super(key: key);

  @override
  State<shoppinglist> createState() => _shoppinglistState();
}

class _shoppinglistState extends State<shoppinglist> {
  @override
  Widget build(BuildContext context) {
    return  list_checkbox();
  }
}

class list_checkbox extends StatefulWidget {
  const list_checkbox({
    super.key,
  });

  @override
  State<list_checkbox> createState() => _list_checkboxState();
}

class _list_checkboxState extends State<list_checkbox> {
  TextEditingController controller=TextEditingController();
  //TextEditingController lablecontroller=TextEditingController();
  String name = '';
  List<Map> categories = [
    //將資料庫裡的資料先放進來
    /*{"title": "蘋果", "isChecked": false},*/
  ];
  @override
  void inidState() {
    super.initState();
  }

  @override
  void dispose() {
    print('購物清單的dispose方法(離開)');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //新增名稱按鈕
          CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                //此按鈕接收dialog中的數值
                  onPressed: () async {
                    final name = await openDialog(context);
                    if (name == null || name.isEmpty) return;
                    setState(() => this.name = name);
                    //將東西新增進去list<map>categories裡面
                    setState(() {
                      categories.add({"title":name,"isChecked": false});
                    });
                  },
                  icon: Image.asset("assets/icons/plus.png"))),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: categories.map((favorite) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      categories.remove(favorite);
                    });
                  },
                  child: CheckboxListTile(
                      title: Text(
                        favorite['title'],
                        style: TextStyle(fontSize: 25),
                      ),
                      activeColor: kPrimaryColor,
                      checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      value: favorite['isChecked'],
                      onChanged: (val) {
                        setState(() {
                          favorite['isChecked'] = val;
                        });
                      }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> openDialog(BuildContext context) => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("新增物品"),
          content: Column(
            children: [
              TextField(
                keyboardType: TextInputType.text,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '名稱：',
                  labelText: 'name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                controller: controller,
                onSubmitted: (_) => submit(),
                onChanged: (text) {
                  print('食材名稱: $text');
                },
              ),
              SizedBox(
                height: 10,
              ),
              /*TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: '數量：',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                controller: lablecontroller,
                onSubmitted: (_) => submit(),
                onChanged: (text) {
                  print('First text field: $text');
                },
              ),*/
            ],
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  //lablecontroller?.clear();
                  controller.clear();
                },
                child: Text("取消")),
            TextButton(onPressed: submit, child: Text("新增")),
          ],
        ),
      );
  void submit() {
    //var va=[controller.text,lablecontroller.text];
    Navigator.of(context)
        .pop(controller.text);
    controller.clear();
  }
}
