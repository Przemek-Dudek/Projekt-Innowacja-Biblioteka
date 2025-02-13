public with sharing class RecordTypesUtility {
    public static Map<String,RecordTypeInfo> recordTypeMap { get; private set; }

    // public static Id getRecordTypeId(String objectName, String recordTypeName) {
    //     Type t=Type.forName(objectName);
    //     if(recordTypeMap == null) {
    //         recordTypeMap = new Map<String,RecordTypeInfo>();
    //     }
    //     SObject currentType = (SObject)t.newInstance();
    //     if(!recordTypeMap.containsKey(objectName+recordTypeName)) {
    //         for(RecordTypeInfo recordTypeInfo : currentType.getSObjectType().getDescribe().getRecordTypeInfosByName().values()) {
    //             recordTypeMap.put(currentType.getSObjectType().getDescribe().getName()+recordTypeInfo.getName(), recordTypeInfo);
    //         }
    //     }
    //     return recordTypeMap.get(objectName+recordTypeName).getRecordTypeId(); 
    // }
    public static Id getRecordTypeId(SobjectType objectType, String recordTypeName) {
        if(recordTypeMap == null) {
            recordTypeMap = new Map<String,RecordTypeInfo>();
        }
        String objectName = objectType.getDescribe().getName();
        if(!recordTypeMap.containsKey(objectName+recordTypeName)) {
            for(RecordTypeInfo recordTypeInfo : objectType.getDescribe().getRecordTypeInfosByName().values()) {
                recordTypeMap.put(objectName+recordTypeInfo.getName(), recordTypeInfo);
            }
        }
        return recordTypeMap.get(objectName+recordTypeName).getRecordTypeId(); 
    }

}