import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../customs/new_transaction.dart';
import '../customs/transaction_card.dart';
import "../customs/header.dart";

import '../models/expense.dart';
import '../providers/transactions.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return GestureDetector(
                  onTap: () {},
                  child: NewTransaction(_done),
                  behavior: HitTestBehavior.opaque,
                );
              });
        },
      ),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Aylık Harcamalar",
          style: TextStyle(fontSize: 18),
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
                              child: Icon(
                            Icons.pause_circle_outline_outlined,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          )),
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
                                        //NewTransaction(_done)
                                      ],
                                    ),
                                    TransactionCard()
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
    await Future.delayed(Duration(milliseconds: 100));
    return null;
  }
}
