public with sharing class ItemRecordTypesUtility {
    public static Map<String,RecordTypeInfo> recordTypeMap { get; private set; }

    public static Id getRecordTypeId(SobjectType sObjectType, String recordTypeName) {
        if(!recordTypeMap.containsKey(sObjectType.getDescribe().getName()+recordTypeName)) {
            for(RecordTypeInfo recordTypeInfo : sObjectType.getDescribe().getRecordTypeInfosByName().values()) {
                recordTypeMap.put(sObjectType.getDescribe().getName()+recordTypeInfo.getName(), recordTypeInfo);
            }

        }
        return recordTypeMap.get(sObjectType.getDescribe().getName()+recordTypeName).getRecordTypeId();    
    }

}