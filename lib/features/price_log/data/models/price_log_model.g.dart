// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_log_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPriceLogModelCollection on Isar {
  IsarCollection<PriceLogModel> get priceLogModels => this.collection();
}

const PriceLogModelSchema = CollectionSchema(
  name: r'PriceLogModel',
  id: 1292558803559634231,
  properties: {
    r'currency': PropertySchema(
      id: 0,
      name: r'currency',
      type: IsarType.string,
    ),
    r'hasReceipt': PropertySchema(
      id: 1,
      name: r'hasReceipt',
      type: IsarType.bool,
    ),
    r'isAvailable': PropertySchema(
      id: 2,
      name: r'isAvailable',
      type: IsarType.bool,
    ),
    r'marketId': PropertySchema(
      id: 3,
      name: r'marketId',
      type: IsarType.string,
    ),
    r'price': PropertySchema(
      id: 4,
      name: r'price',
      type: IsarType.double,
    ),
    r'productId': PropertySchema(
      id: 5,
      name: r'productId',
      type: IsarType.string,
    ),
    r'receiptImageUrl': PropertySchema(
      id: 6,
      name: r'receiptImageUrl',
      type: IsarType.string,
    ),
    r'syncStatus': PropertySchema(
      id: 7,
      name: r'syncStatus',
      type: IsarType.byte,
      enumMap: _PriceLogModelsyncStatusEnumValueMap,
    ),
    r'timestamp': PropertySchema(
      id: 8,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'userId': PropertySchema(
      id: 9,
      name: r'userId',
      type: IsarType.string,
    ),
    r'uuid': PropertySchema(
      id: 10,
      name: r'uuid',
      type: IsarType.string,
    )
  },
  estimateSize: _priceLogModelEstimateSize,
  serialize: _priceLogModelSerialize,
  deserialize: _priceLogModelDeserialize,
  deserializeProp: _priceLogModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'productId': IndexSchema(
      id: 5580769080710688203,
      name: r'productId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'productId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _priceLogModelGetId,
  getLinks: _priceLogModelGetLinks,
  attach: _priceLogModelAttach,
  version: '3.1.0+1',
);

int _priceLogModelEstimateSize(
  PriceLogModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.marketId.length * 3;
  bytesCount += 3 + object.productId.length * 3;
  {
    final value = object.receiptImageUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.userId.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  return bytesCount;
}

void _priceLogModelSerialize(
  PriceLogModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.currency);
  writer.writeBool(offsets[1], object.hasReceipt);
  writer.writeBool(offsets[2], object.isAvailable);
  writer.writeString(offsets[3], object.marketId);
  writer.writeDouble(offsets[4], object.price);
  writer.writeString(offsets[5], object.productId);
  writer.writeString(offsets[6], object.receiptImageUrl);
  writer.writeByte(offsets[7], object.syncStatus.index);
  writer.writeDateTime(offsets[8], object.timestamp);
  writer.writeString(offsets[9], object.userId);
  writer.writeString(offsets[10], object.uuid);
}

PriceLogModel _priceLogModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PriceLogModel();
  object.currency = reader.readString(offsets[0]);
  object.hasReceipt = reader.readBool(offsets[1]);
  object.id = id;
  object.isAvailable = reader.readBool(offsets[2]);
  object.marketId = reader.readString(offsets[3]);
  object.price = reader.readDouble(offsets[4]);
  object.productId = reader.readString(offsets[5]);
  object.receiptImageUrl = reader.readStringOrNull(offsets[6]);
  object.syncStatus =
      _PriceLogModelsyncStatusValueEnumMap[reader.readByteOrNull(offsets[7])] ??
          SyncStatus.synced;
  object.timestamp = reader.readDateTime(offsets[8]);
  object.userId = reader.readString(offsets[9]);
  object.uuid = reader.readString(offsets[10]);
  return object;
}

P _priceLogModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (_PriceLogModelsyncStatusValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SyncStatus.synced) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PriceLogModelsyncStatusEnumValueMap = {
  'synced': 0,
  'pending': 1,
  'failed': 2,
};
const _PriceLogModelsyncStatusValueEnumMap = {
  0: SyncStatus.synced,
  1: SyncStatus.pending,
  2: SyncStatus.failed,
};

Id _priceLogModelGetId(PriceLogModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _priceLogModelGetLinks(PriceLogModel object) {
  return [];
}

void _priceLogModelAttach(
    IsarCollection<dynamic> col, Id id, PriceLogModel object) {
  object.id = id;
}

extension PriceLogModelByIndex on IsarCollection<PriceLogModel> {
  Future<PriceLogModel?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  PriceLogModel? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<PriceLogModel?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<PriceLogModel?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(PriceLogModel object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(PriceLogModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<PriceLogModel> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<PriceLogModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension PriceLogModelQueryWhereSort
    on QueryBuilder<PriceLogModel, PriceLogModel, QWhere> {
  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PriceLogModelQueryWhere
    on QueryBuilder<PriceLogModel, PriceLogModel, QWhereClause> {
  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause> uuidNotEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause>
      productIdEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'productId',
        value: [productId],
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterWhereClause>
      productIdNotEqualTo(String productId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [productId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'productId',
              lower: [],
              upper: [productId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension PriceLogModelQueryFilter
    on QueryBuilder<PriceLogModel, PriceLogModel, QFilterCondition> {
  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      hasReceiptEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasReceipt',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      isAvailableEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAvailable',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'marketId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'marketId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'marketId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'marketId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      marketIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'marketId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'productId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'productId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'productId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'receiptImageUrl',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'receiptImageUrl',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'receiptImageUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'receiptImageUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'receiptImageUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'receiptImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      receiptImageUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'receiptImageUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      syncStatusEqualTo(SyncStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      syncStatusGreaterThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      syncStatusLessThan(
    SyncStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncStatus',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      syncStatusBetween(
    SyncStatus lower,
    SyncStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncStatus',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      userIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userId',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition> uuidMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }
}

extension PriceLogModelQueryObject
    on QueryBuilder<PriceLogModel, PriceLogModel, QFilterCondition> {}

extension PriceLogModelQueryLinks
    on QueryBuilder<PriceLogModel, PriceLogModel, QFilterCondition> {}

extension PriceLogModelQuerySortBy
    on QueryBuilder<PriceLogModel, PriceLogModel, QSortBy> {
  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByHasReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByMarketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByMarketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByReceiptImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByReceiptImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PriceLogModelQuerySortThenBy
    on QueryBuilder<PriceLogModel, PriceLogModel, QSortThenBy> {
  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByHasReceiptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReceipt', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByIsAvailableDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAvailable', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByMarketId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByMarketIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'marketId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByReceiptImageUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByReceiptImageUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'receiptImageUrl', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenBySyncStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncStatus', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QAfterSortBy> thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }
}

extension PriceLogModelQueryWhereDistinct
    on QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> {
  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByCurrency(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByHasReceipt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReceipt');
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct>
      distinctByIsAvailable() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAvailable');
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByMarketId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'marketId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByProductId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct>
      distinctByReceiptImageUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'receiptImageUrl',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctBySyncStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncStatus');
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByUserId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PriceLogModel, PriceLogModel, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }
}

extension PriceLogModelQueryProperty
    on QueryBuilder<PriceLogModel, PriceLogModel, QQueryProperty> {
  QueryBuilder<PriceLogModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PriceLogModel, String, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<PriceLogModel, bool, QQueryOperations> hasReceiptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReceipt');
    });
  }

  QueryBuilder<PriceLogModel, bool, QQueryOperations> isAvailableProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAvailable');
    });
  }

  QueryBuilder<PriceLogModel, String, QQueryOperations> marketIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'marketId');
    });
  }

  QueryBuilder<PriceLogModel, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<PriceLogModel, String, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<PriceLogModel, String?, QQueryOperations>
      receiptImageUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'receiptImageUrl');
    });
  }

  QueryBuilder<PriceLogModel, SyncStatus, QQueryOperations>
      syncStatusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncStatus');
    });
  }

  QueryBuilder<PriceLogModel, DateTime, QQueryOperations> timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }

  QueryBuilder<PriceLogModel, String, QQueryOperations> userIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<PriceLogModel, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }
}
