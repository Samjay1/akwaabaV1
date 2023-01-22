class Subscription {
  int? id;
  String? client;
  String? clientId;
  String? subscriptionId;
  SubscribedModules? subscribedModules;
  String? dateCreated;

  Subscription({
    this.id,
    this.client,
    this.clientId,
    this.subscriptionId,
    this.subscribedModules,
    this.dateCreated,
  });

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    client = json['client'];
    clientId = json['client_id'];
    subscriptionId = json['subscription_id'];
    subscribedModules = json['subscribed_modules'] != null
        ? SubscribedModules.fromJson(json['subscribed_modules'])
        : null;
    dateCreated = json['date_created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['client'] = client;
    data['client_id'] = clientId;
    data['subscription_id'] = subscriptionId;
    if (subscribedModules != null) {
      data['subscribed_modules'] = subscribedModules!.toJson();
    }
    data['date_created'] = dateCreated;
    return data;
  }
}

class SubscribedModules {
  Module? module1;
  Module? module2;
  Module? module3;

  SubscribedModules({this.module1, this.module2, this.module3});

  SubscribedModules.fromJson(Map<String, dynamic> json) {
    module1 =
        json['Module 1'] != null ? Module.fromJson(json['Module 1']) : null;
    module2 =
        json['Module 2'] != null ? Module.fromJson(json['Module 2']) : null;
    module3 =
        json['Module 3'] != null ? Module.fromJson(json['Module 3']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (module1 != null) {
      data['Module 1'] = module1!.toJson();
    }
    if (module2 != null) {
      data['Module 2'] = module2!.toJson();
    }
    if (module3 != null) {
      data['Module 3'] = module3!.toJson();
    }
    return data;
  }
}

class Module {
  int? moduleId;
  String? moduleName;
  String? expiresOn;

  Module({this.moduleId, this.moduleName, this.expiresOn});

  Module.fromJson(Map<String, dynamic> json) {
    moduleId = json['module_id'];
    moduleName = json['module_name'];
    expiresOn = json['expires_on'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['module_id'] = moduleId;
    data['module_name'] = moduleName;
    data['expires_on'] = expiresOn;
    return data;
  }
}
