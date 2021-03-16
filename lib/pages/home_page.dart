import 'package:flutter/material.dart';
import 'package:flutter_finans/customs/new_transaction.dart';
import 'package:flutter_finans/customs/transaction_card.dart';
import 'package:flutter_finans/models/expense.dart';
import 'package:flutter_finans/providers/transactions.dart';
import 'package:provider/provider.dart';
import "../customs/header.dart";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _done() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _transactionModel = Provider.of<Transactions>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.short_text,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        centerTitle: true,
        title: Text(
          "Aylık Harcamalar",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return FutureBuilder(
                future: _transactionModel.getAllExpense(),
                builder: (context, AsyncSnapshot<List<Expense>> snapshot) {
                  if (!snapshot.hasData)
                    return RefreshIndicator(
                      onRefresh: _refreshList,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height - 150,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.supervised_user_circle,
                                  color: Theme.of(context).primaryColor,
                                  size: 120,
                                ),
                                Text(
                                  "Kullanıcı yok..",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(.3),
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  else
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Header(snapshot.data),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .03,
                                        ),
                                        NewTransaction(_done)
                                      ],
                                    ),
                                    TransactionCard(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                });
          },
        ),
      ),
    );
  }

  Future<Null> _refreshList() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 700));
    return null;
  }
}