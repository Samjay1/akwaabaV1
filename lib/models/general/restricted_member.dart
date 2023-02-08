import 'package:akwaaba/models/admin/clocked_member.dart';
import 'package:akwaaba/models/general/branch.dart';
import 'package:akwaaba/models/general/constiteuncy.dart';
import 'package:akwaaba/models/general/district.dart';
import 'package:akwaaba/models/general/group.dart';
import 'package:akwaaba/models/general/member_category.dart';
import 'package:akwaaba/models/general/region.dart';
import 'package:akwaaba/models/general/restriction.dart';
import 'package:akwaaba/models/general/subgroup.dart';

class RestrictedMember {
  int? id;
  Member? member;
  AccountType? accountType;
  Branch? branch;
  MemberCategory? category;
  List<Restriction>? restriction;
  List<Group>? group;
  List<SubGroup>? subgroup;
  Contacts? contacts;
  Location? location;
  String? identification;

  RestrictedMember({
    this.id,
    this.member,
    this.accountType,
    this.branch,
    this.category,
    this.restriction,
    this.group,
    this.subgroup,
    this.contacts,
    this.location,
    this.identification,
  });

  RestrictedMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    member = json['member'] != null ? Member.fromJson(json['member']) : null;
    accountType = json['accountType'] != null
        ? AccountType.fromJson(json['accountType'])
        : null;
    branch = json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    category = json['category'] != null
        ? MemberCategory.fromJson(json['category'])
        : null;
    if (json['restriction'] != null) {
      restriction = <Restriction>[];
      json['restriction'].forEach((v) {
        restriction!.add(Restriction.fromJson(v));
      });
    }
    if (json['group'] != null) {
      group = <Group>[];
      json['group'].forEach((v) {
        group!.add(Group.fromJson(v));
      });
    }
    if (json['subgroup'] != null) {
      subgroup = <SubGroup>[];
      json['subgroup'].forEach((v) {
        subgroup!.add(SubGroup.fromJson(v));
      });
    }
    contacts =
        json['contacts'] != null ? Contacts.fromJson(json['contacts']) : null;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    identification = json['identification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (member != null) {
      data['member'] = member!.toJson();
    }
    if (accountType != null) {
      data['accountType'] = accountType!.toJson();
    }
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (restriction != null) {
      data['restriction'] = restriction!.map((v) => v.toJson()).toList();
    }
    if (group != null) {
      data['group'] = group!.map((v) => v.toJson()).toList();
    }
    if (subgroup != null) {
      data['subgroup'] = subgroup!.map((v) => v.toJson()).toList();
    }
    if (contacts != null) {
      data['contacts'] = contacts!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['identification'] = identification;
    return data;
  }
}

class AccountType {
  int? id;
  String? name;

  AccountType({this.id, this.name});

  AccountType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Contacts {
  Contact? contact;
  dynamic privacy;

  Contacts({this.contact, this.privacy});

  Contacts.fromJson(Map<String, dynamic> json) {
    contact =
        json['contact'] != null ? Contact.fromJson(json['contact']) : null;
    privacy = json['privacy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    data['privacy'] = privacy;
    return data;
  }
}

class Contact {
  int? id;
  int? memberId;
  String? phone;
  String? email;
  String? placeOfWork;
  String? whatsapp;
  String? facebook;
  String? twitter;
  String? instagram;
  dynamic accountBio;
  String? businessHashtag;
  String? businessDescription;
  String? profession;
  dynamic website;
  dynamic postalAddress;
  dynamic digitalAddress;
  String? dateJoined;
  String? date;

  Contact({
    this.id,
    this.memberId,
    this.phone,
    this.email,
    this.placeOfWork,
    this.whatsapp,
    this.facebook,
    this.twitter,
    this.instagram,
    this.accountBio,
    this.businessHashtag,
    this.businessDescription,
    this.profession,
    this.website,
    this.postalAddress,
    this.digitalAddress,
    this.dateJoined,
    this.date,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    phone = json['phone'];
    email = json['email'];
    placeOfWork = json['placeOfWork'];
    whatsapp = json['whatsapp'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    accountBio = json['accountBio'];
    businessHashtag = json['businessHashtag'];
    businessDescription = json['businessDescription'];
    profession = json['profession'];
    website = json['website'];
    postalAddress = json['postalAddress'];
    digitalAddress = json['digitalAddress'];
    dateJoined = json['dateJoined'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['memberId'] = memberId;
    data['phone'] = phone;
    data['email'] = email;
    data['placeOfWork'] = placeOfWork;
    data['whatsapp'] = whatsapp;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['instagram'] = instagram;
    data['accountBio'] = accountBio;
    data['businessHashtag'] = businessHashtag;
    data['businessDescription'] = businessDescription;
    data['profession'] = profession;
    data['website'] = website;
    data['postalAddress'] = postalAddress;
    data['digitalAddress'] = digitalAddress;
    data['dateJoined'] = dateJoined;
    data['date'] = date;
    return data;
  }
}

class Location {
  Region? region;
  District? district;
  Constituency? constituency;
  dynamic electoralArea;

  Location({this.region, this.district, this.constituency, this.electoralArea});

  Location.fromJson(Map<String, dynamic> json) {
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
    district =
        json['district'] != null ? District.fromJson(json['district']) : null;
    constituency = json['constituency'] != null
        ? Constituency.fromJson(json['constituency'])
        : null;
    electoralArea = json['electoralArea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (region != null) {
      data['region'] = region!.toJson();
    }
    if (district != null) {
      data['district'] = district!.toJson();
    }
    if (constituency != null) {
      data['constituency'] = constituency!.toJson();
    }
    data['electoralArea'] = electoralArea;
    return data;
  }
}
