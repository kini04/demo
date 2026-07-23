[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
shared DefaultDestination = let
  Source = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  #"Navigation 1" = Source{[workspaceId = "8979ce71-bad5-4e61-803f-cadbb866fe13"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[lakehouseId = "838410f2-7d3a-43f1-a78a-4c244aa7447e"]}[Data],
  #"Navigation 3" = #"Navigation 2"{[Id = "dbo", ItemKind = "Schema"]}[Data]
in
  #"Navigation 3";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "orders_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "LineItem", DestinationColumnName = "LineItem"], [SourceColumnName = "TotalQtyByLineItem", DestinationColumnName = "TotalQtyByLineItem"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared orders = let
  Source = Lakehouse.Contents(null),
  Navigation = Source{[workspaceId = "8979ce71-bad5-4e61-803f-cadbb866fe13"]}[Data],
  #"Navigation 1" = Navigation{[lakehouseId = "838410f2-7d3a-43f1-a78a-4c244aa7447e"]}[Data],
  #"Navigation 2" = #"Navigation 1"{[Id = "orders", ItemKind = "Table"]}[Data],
  #"Changed column type" = Table.TransformColumnTypes(#"Navigation 2", {{"LineItem", Int64.Type}}),
  #"Grouped rows" = Table.Group(#"Changed column type", {"LineItem"}, {{"TotalQtyByLineItem", each List.Sum([OrderQty]), type nullable number}}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Grouped rows", {{"TotalQtyByLineItem", Int64.Type}})
in
  #"Changed column type 1";
shared orders_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "8979ce71-bad5-4e61-803f-cadbb866fe13"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "838410f2-7d3a-43f1-a78a-4c244aa7447e"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "LineItemTotalOrders", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
