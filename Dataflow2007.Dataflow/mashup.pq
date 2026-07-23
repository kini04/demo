[StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "salesdata_DataDestination", IsNewTarget = true], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "CustomerName", DestinationColumnName = "CustomerName"], [SourceColumnName = "EmailAddress", DestinationColumnName = "EmailAddress"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "UnitPrice", DestinationColumnName = "UnitPrice"], [SourceColumnName = "TaxAmount", DestinationColumnName = "TaxAmount"], [SourceColumnName = "PriceAfterTax", DestinationColumnName = "PriceAfterTax"], [SourceColumnName = "highend", DestinationColumnName = "highend"]}], DynamicSchema = true, UpdateMethod = [Kind = "Replace"], TypeSettings = [Kind = "Table"]]]}]
shared salesdata = let
  Source = Csv.Document(Web.Contents("https://github.com/MicrosoftLearning/dp-data/raw/main/sales.csv"), [Delimiter = ",", Columns = 9, Encoding = 65001, QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"SalesOrderNumber", type text}, {"SalesOrderLineNumber", Int64.Type}, {"OrderDate", type date}, {"CustomerName", type text}, {"EmailAddress", type text}, {"Item", type text}, {"Quantity", Int64.Type}, {"UnitPrice", type number}, {"TaxAmount", type number}}),
  #"Added custom" = Table.TransformColumnTypes(Table.AddColumn(#"Changed column type", "PriceAfterTax", each [UnitPrice] + [TaxAmount]), {{"PriceAfterTax", Currency.Type}}),
  #"Inserted conditional column" = Table.AddColumn(#"Added custom", "highend", each if [UnitPrice] > 2000 then true else false),
  #"Choose columns" = Table.SelectColumns(#"Inserted conditional column", {"CustomerName", "EmailAddress", "Item", "Quantity", "UnitPrice", "TaxAmount", "PriceAfterTax", "highend"}),
  #"Changed column type 1" = Table.TransformColumnTypes(#"Choose columns", {{"highend", type logical}})
in
  #"Changed column type 1";
shared salesdata_DataDestination = let
  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),
  Navigation_1 = Pattern{[workspaceId = "8979ce71-bad5-4e61-803f-cadbb866fe13"]}[Data],
  Navigation_2 = Navigation_1{[lakehouseId = "838410f2-7d3a-43f1-a78a-4c244aa7447e"]}[Data],
  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],
  TableNavigation = Navigation_3{[Id = "salesdata", ItemKind = "Table"]}?[Data]?
in
  TableNavigation;
