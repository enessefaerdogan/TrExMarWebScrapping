
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart'  as dom;
import 'package:web_scraping3/models/share.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final url = Uri.parse("https://www.haberturk.com/ekonomi/borsa/bist-100");
  List<String> myDatas = [];
  List<Share> shares = [];
  var second = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    timerMethod();
    fetchData();
    
  }

  
  timerMethod(){

    Timer.periodic(Duration(seconds: 1), (timer) { 

      setState(() {
        second ++;
        if(second==60){
          fetchData();
          second=0;
        }
      });
    });
  }

  Future fetchData() async{
   final response = await http.get(url);
   
   dom.Document html = dom.Document.html(response.body);

  final titles = html
   .querySelectorAll("div > a > span.text-sm")
   .map((e) => e.innerHtml.trim()).toList();

  final subtitles = html
   .querySelectorAll("div > a > span.text-xxs.text-ellipsis.line-clamp-2")
   .map((e) => e.innerHtml.trim()).toList();
   print(subtitles);

  var count = 0;
  List<String> percents = [];
  final percent = html
  .getElementsByClassName("flex min-w-max")
  .forEach((e) {
    
    String value = ""; 
    
    for(int i=0;i<e.innerHtml.length;i++){
        if(e.innerHtml[i]=="%"){
          setState(() {
            value = ((e.innerHtml[i-6]!=">" && e.innerHtml[i-6]!='"'  )  ? e.innerHtml[i-6] :"") 
            +((e.innerHtml[i-5]!=">" && e.innerHtml[i-5]!='"')   ? e.innerHtml[i-5] :"") 
            + ((e.innerHtml[i-4]!=">" && e.innerHtml[i-4]!='"')   ? e.innerHtml[i-4] :"") 
            + ((e.innerHtml[i-3]!=">" && e.innerHtml[i-3]!='"')   ? e.innerHtml[i-3] :"")  
            + ((e.innerHtml[i-2]!=">" && e.innerHtml[i-2]!='"')   ? e.innerHtml[i-2] :"")  
            + ((e.innerHtml[i-1]!=">" && e.innerHtml[i-1]!='"')   ? e.innerHtml[i-1] :"") 
            + ((e.innerHtml[i]!=">" && e.innerHtml[i]!='"')   ? e.innerHtml[i] :"") ;

            percents.add(value.trim());
          });
        }
    }
    print("Sıra:"+count.toString()+"Yüzde:"+value);
    count++;
    }
    
    );

  List<String> prices = [];
  final priceContainer = html.querySelectorAll(".min-w-max");

  for(int i=0;i<priceContainer.length;i++){
    if(i%2==0){
      setState(() {
      prices.add(priceContainer[i].innerHtml.trim());
     });
   }
  }


setState(() {
  shares = List.generate(titles.length, (index) => Share(
    title: titles[index], 
    subtitle: subtitles[index], 
    value: prices[index], 
    percent: percents[index]));
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        appBar: AppBar(title: Text("BIST100 Hisseler",
        style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold))),

        body: Column(
          children: [

            Row(children: [
              
              Container(margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.04),child: Text("ENDEKS",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
              SizedBox(width: MediaQuery.of(context).size.width*0.24,),
              Container(child: Text("FİYAT",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
              SizedBox(width: MediaQuery.of(context).size.width*0.19,),
              Container(child: Text("FARK",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)),
            
              ],),
              Divider(thickness: 1,color: Colors.black38,),
            Expanded(
              child: ListView.builder(
                itemCount: shares.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
            
                  return ListTile(
            
                    title: Row(
                      children: [
                        Container(width: MediaQuery.of(context).size.width*0.2,
                        child: Text(shares[index].title)),
                        SizedBox(width: MediaQuery.of(context).size.width*0.23,),
                        Container(
                        width: MediaQuery.of(context).size.width*0.28,child: Text("${shares[index].value.trim()} TL",style: TextStyle(color: Colors.black,fontSize: 15),)),
                        SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                        Text(shares[index].percent,style: TextStyle(color: shares[index].percent.contains("-") ? Colors.red : Colors.green,fontSize: 15)),
            
                      ],
                    ),
                    subtitle: Text(shares[index].subtitle,style: TextStyle(color: Colors.black38,fontSize: 10),),
                    
                  );
            
              }),
            ),
          ],
        ),


    );
  }
}