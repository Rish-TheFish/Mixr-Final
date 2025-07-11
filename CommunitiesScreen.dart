import 'package:flutter/material.dart';
import 'TermsContentScreen.dart';
// import 'dart:io';
// import 'dart:math';
// import 'dart:convert';
// import 'DemographicsScreen.dart';
// import 'TermScreen.dart';
// import 'WelcomeScreen.dart';
// import 'Buttons.dart';
// import 'TheBarScreen.dart';
// import 'DrinkScreen.dart';
// import 'TasteScreen.dart';
// import 'db_helper.dart';


class CommunityHomePage extends StatefulWidget {
  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  final List<String> allCommunities = [
    'Whiskey Lovers',
    'Vodka Enthusiasts',
    'Tequila Sippers',
    'Rum Runners',
    'Craft Beer Nerds',
    'Gin Appreciation Society',
    'Wine Snobs',
  ];

  final Set<String> joinedCommunities = {};
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> privateServers = [];

  void _createServer() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreatePrivateServerPage(),
      ),
    );

    if (result != null) {
      setState(() {
        privateServers.add(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.toLowerCase();
    final filtered = allCommunities
        .where((c) => c.toLowerCase().contains(query))
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Alcohol Communities'),
          bottom: TabBar(tabs: [
            Tab(text: 'Explore'),
            Tab(text: 'My Communities'),
            Tab(text: 'Private Servers'),
          ]),
        ),
        body: TabBarView(
          children: [
            // Explore Tab
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Communities',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: filtered.map((community) {
                      final isJoined = joinedCommunities.contains(community);
                      return ListTile(
                        title: Text(community),
                        trailing: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isJoined
                                  ? joinedCommunities.remove(community)
                                  : joinedCommunities.add(community);
                            });
                          },
                          child: Text(isJoined ? 'Leave' : 'Join'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            // My Communities Tab
            ListView(
              children: joinedCommunities.map((community) {
                return ListTile(
                  title: Text(community),
                  trailing: Icon(Icons.chat),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(communityName: community),
                    ),
                  ),
                );
              }).toList(),
            ),

            // Private Servers Tab
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _createServer,
                  icon: Icon(Icons.add),
                  label: Text("Create Private Server"),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: privateServers.length,
                    itemBuilder: (_, index) {
                      final server = privateServers[index];
                      return ListTile(
                        title: Text(server['name']),
                        subtitle: Text("Members: ${server['members'].join(', ')}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PrivateChatPage(
                                serverName: server['name'],
                                members: server['members'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreatePrivateServerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Server")),
      body: Center(child: Text("Private server creation form goes here.")),
    );
  }
}

class PrivateChatPage extends StatelessWidget {
  final String serverName;
  final List<String> members;

  PrivateChatPage({required this.serverName, required this.members});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serverName)),
      body: Center(child: Text("Chatroom for private server: $serverName")),
    );
  }
}

// part 2
class ChatPage extends StatefulWidget {
  final String communityName;
  ChatPage({required this.communityName});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> chat = [];
  PartyInvite? attachedInvite;
  Map<String, dynamic>? sharedDrinkAttachment;

  void sendMessage() {
    if (_messageController.text.trim().isEmpty &&
        attachedInvite == null &&
        sharedDrinkAttachment == null) return;

    chat.add({
      'message': _messageController.text.trim(),
      'invite': attachedInvite,
      'sharedDrink': sharedDrinkAttachment,
    });

    _messageController.clear();
    setState(() {
      attachedInvite = null;
      sharedDrinkAttachment = null;
    });
  }

  void openAttachmentOptions() async {
    final result = await showDialog(
      context: context,
      builder: (_) => AttachmentOptionsDialog(),
    );

    if (result == 'party_invite') {
      final invite = await showDialog(
        context: context,
        builder: (_) => PartySetupDialog(),
      );
      if (invite != null && invite is PartyInvite) {
        setState(() {
          attachedInvite = invite;
        });
      }
    }

    if (result == 'favorite_drink') {
      final sharedDrink = await showDialog(
        context: context,
        builder: (_) => ShareDrinkDialog(),
      );
      if (sharedDrink != null) {
        setState(() {
          sharedDrinkAttachment = sharedDrink;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.communityName)),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chat.length,
              itemBuilder: (_, index) {
                final item = chat[index];
                return ListTile(
                  title: Text(item['message'] ?? ''),
                  subtitle: item['invite'] != null
                      ? GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (_) =>
                                PartyInvitePopup(invite: item['invite']),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(top: 5),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.blue.shade50,
                            ),
                            child: Text(
                                "📍 Party at ${item['invite'].location} — Tap to view"),
                          ),
                        )
                      : item['sharedDrink'] != null
                          ? Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green.shade50,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "🍸 ${item['sharedDrink']['drink']}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Ingredients: ${item['sharedDrink']['ingredients'].join(', ')}",
                                  ),
                                  if (item['sharedDrink']['note'] != '')
                                    Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Text(
                                          "💬 ${item['sharedDrink']['note']}"),
                                    ),
                                ],
                              ),
                            )
                          : null,
                );
              },
            ),
          ),
          if (attachedInvite != null)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_bar),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          "Attached Party Invite: ${attachedInvite!.location}")),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => setState(() => attachedInvite = null),
                  )
                ],
              ),
            ),
          if (sharedDrinkAttachment != null)
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          "Attached Drink: ${sharedDrinkAttachment!['drink']}")),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () =>
                        setState(() => sharedDrinkAttachment = null),
                  )
                ],
              ),
            ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.add), onPressed: openAttachmentOptions),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(hintText: 'Type your message...'),
                ),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
            ],
          ),
        ],
      ),
    );
  }
}

// part 3

class AttachmentOptionsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Attach something"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, 'party_invite'),
          child: Row(
              children: [Icon(Icons.local_bar), SizedBox(width: 8), Text("Party Invite")]),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context, 'favorite_drink'),
          child: Row(
              children: [Icon(Icons.favorite), SizedBox(width: 8), Text("Share Favorite Drink")]),
        ),
      ],
    );
  }
}

class ShareDrinkDialog extends StatefulWidget {
  @override
  _ShareDrinkDialogState createState() => _ShareDrinkDialogState();
}

class _ShareDrinkDialogState extends State<ShareDrinkDialog> {
  final Map<String, List<String>> drinkBook = {
    'Margarita': ['tequila', 'lime juice', 'triple sec'],
    'Whiskey Sour': ['whiskey', 'lemon juice', 'sugar syrup'],
    'Rum Punch': ['rum', 'pineapple juice', 'orange juice'],
    'Gin and Tonic': ['gin', 'tonic water'],
  };

  String? selectedDrink;
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Share Favorite Drink'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: selectedDrink,
            hint: Text("Select a drink"),
            items: drinkBook.keys.map((drink) {
              return DropdownMenuItem(
                value: drink,
                child: Text(drink),
              );
            }).toList(),
            onChanged: (val) => setState(() => selectedDrink = val),
          ),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(hintText: "Optional note (e.g. Try this!)"),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(
          onPressed: selectedDrink != null
              ? () {
                  Navigator.pop(context, {
                    'drink': selectedDrink,
                    'ingredients': drinkBook[selectedDrink],
                    'note': _noteController.text.trim(),
                  });
                }
              : null,
          child: Text("Send"),
        ),
      ],
    );
  }
}

class PartyInvite {
  final String location;
  final List<String> organizerIngredients;
  final List<String> attendeeIngredients;
  final List<String> rsvps;

  PartyInvite({
    required this.location,
    required this.organizerIngredients,
    this.attendeeIngredients = const [],
    this.rsvps = const [],
  });

  List<String> get allIngredients => [...organizerIngredients, ...attendeeIngredients];

  bool hasMoreThanHalf(List<String> required, List<String> available) {
    int count = required.where((item) => available.contains(item)).length;
    return count / required.length >= 0.5 && count != required.length;
  }

  List<String> getMakeableDrinks(Map<String, List<String>> drinkBook) {
    final Set<String> available = allIngredients.toSet();
    return drinkBook.entries
        .where((e) => e.value.every(available.contains))
        .map((e) => e.key)
        .toList();
  }

  List<String> getAlmostMakeableDrinks(Map<String, List<String>> drinkBook) {
    return drinkBook.entries
        .where((e) => hasMoreThanHalf(e.value, allIngredients))
        .map((e) => e.key)
        .toList();
  }
}

class PartySetupDialog extends StatefulWidget {
  @override
  _PartySetupDialogState createState() => _PartySetupDialogState();
}

class _PartySetupDialogState extends State<PartySetupDialog> {
  final _locationController = TextEditingController();
  final _ingredientController = TextEditingController();
  final List<String> ingredients = [];

  void addIngredient() {
    final value = _ingredientController.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        ingredients.add(value.toLowerCase());
        _ingredientController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Start a Party'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(controller: _locationController, decoration: InputDecoration(labelText: 'Location')),
            Row(
              children: [
                Expanded(child: TextField(controller: _ingredientController, decoration: InputDecoration(labelText: 'Ingredient'))),
                IconButton(icon: Icon(Icons.add), onPressed: addIngredient),
              ],
            ),
            Wrap(children: ingredients.map((e) => Chip(label: Text(e))).toList())
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_locationController.text.isNotEmpty) {
              Navigator.pop(context, PartyInvite(location: _locationController.text, organizerIngredients: ingredients));
            }
          },
          child: Text('Send Invite'),
        )
      ],
    );
  }
}

class PartyInvitePopup extends StatelessWidget {
  final PartyInvite invite;
  final Map<String, List<String>> drinkBook = {
    'Margarita': ['tequila', 'lime juice', 'triple sec'],
    'Whiskey Sour': ['whiskey', 'lemon juice', 'sugar syrup'],
    'Rum Punch': ['rum', 'pineapple juice', 'orange juice'],
    'Gin and Tonic': ['gin', 'tonic water'],
  };

  PartyInvitePopup({required this.invite});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('🎉 Party Invite!'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Location: ${invite.location}'),
        SizedBox(height: 10),
        Text('Want to join?'),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text('No')),
        ElevatedButton(
          onPressed: () async {
            final updatedInvite = await showDialog(
              context: context,
              builder: (_) => RSVPIngredientDialog(invite: invite, drinkBook: drinkBook),
            );
            Navigator.pop(context);
          },
          child: Text('Yes'),
        ),
      ],
    );
  }
}

class RSVPIngredientDialog extends StatefulWidget {
  final PartyInvite invite;
  final Map<String, List<String>> drinkBook;

  RSVPIngredientDialog({required this.invite, required this.drinkBook});

  @override
  _RSVPIngredientDialogState createState() => _RSVPIngredientDialogState();
}

class _RSVPIngredientDialogState extends State<RSVPIngredientDialog> {
  final _ingredientController = TextEditingController();
  List<String> contributions = [];

  void addIngredient() {
    final value = _ingredientController.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        contributions.add(value.toLowerCase());
        _ingredientController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final combinedInvite = PartyInvite(
      location: widget.invite.location,
      organizerIngredients: widget.invite.organizerIngredients,
      attendeeIngredients: contributions,
    );
    final possibleDrinks = combinedInvite.getMakeableDrinks(widget.drinkBook);
    final nearDrinks = combinedInvite.getAlmostMakeableDrinks(widget.drinkBook);

    return AlertDialog(
      title: Text('RSVP & Contribute'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text('Organizer Ingredients: ${widget.invite.organizerIngredients.join(', ')}'),
            Text('Your Contributions: ${contributions.join(', ')}'),
            Row(
              children: [
                Expanded(child: TextField(controller: _ingredientController, decoration: InputDecoration(labelText: 'Add Ingredient'))),
                IconButton(icon: Icon(Icons.add), onPressed: addIngredient),
              ],
            ),
            SizedBox(height: 10),
            Text('🍹 Can Make:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...possibleDrinks.map((d) => Text(d)),
            SizedBox(height: 10),
            Text('🌟 Almost There:', style: TextStyle(fontWeight: FontWeight.bold)),
            ...nearDrinks.map((d) => Text(d)),
          ],
        ),
      ),
      actions: [
        ElevatedButton(onPressed: () => Navigator.pop(context, combinedInvite), child: Text('Done')),
      ],
    );
  }
}


