package wslargedataio;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import us.kbase.auth.AuthToken;
import us.kbase.common.service.Tuple11;
import us.kbase.common.service.UObject;
import us.kbase.workspace.GetObjects2Params;
import us.kbase.workspace.ProvenanceAction;
import us.kbase.workspace.WorkspaceClient;

public class WsLargeDataIOImpl {

    public static List<Tuple11<Long, String, String, String, Long, String, Long, String,
    String, Long, Map<String,String>>> saveObjects(SaveObjectsParams params, AuthToken token,
            Map<String, String> config, List<ProvenanceAction> provenance) throws Exception {
        WorkspaceClient wc = new WorkspaceClient(new URL(config.get("workspace-url")), 
                token);
        wc.setIsInsecureHttpConnectionAllowed(true);
        wc.setStreamingModeOn(true);
        List<us.kbase.workspace.ObjectSaveData> objects = 
                new ArrayList<us.kbase.workspace.ObjectSaveData>();
        for (ObjectSaveData osd : params.getObjects()) {
            File file = new File(osd.getDataJsonFile());
            objects.add(
                    new us.kbase.workspace.ObjectSaveData().withType(osd.getType())
                    .withData(new UObject(file)).withHidden(osd.getHidden())
                    .withMeta(osd.getMeta()).withName(osd.getName())
                    .withObjid(osd.getObjid()).withProvenance(provenance));
        }
        us.kbase.workspace.SaveObjectsParams soParams = 
                new us.kbase.workspace.SaveObjectsParams().withId(params.getId())
                .withWorkspace(params.getWorkspace())
                .withObjects(objects);
        return wc.saveObjects(soParams);
    }

    public static GetObjectsResults getObjects(GetObjectsParams params, AuthToken token,
            Map<String, String> config) throws Exception {
        File tempDir = new File(config.get("scratch"));
        File tempFile = File.createTempFile("ws_srv_response_", ".json", tempDir);
        try {
            WorkspaceClient wc = new WorkspaceClient(new URL(config.get("workspace-url")), 
                    token);
            wc.setIsInsecureHttpConnectionAllowed(true);
            wc.setStreamingModeOn(true);
            wc._setFileForNextRpcResponse(tempFile);
            List<us.kbase.workspace.ObjectSpecification> objects = new ArrayList<>();
            for (ObjectSpecification os : params.getObjects()) {
                objects.add(new us.kbase.workspace.ObjectSpecification().withRef(os.getRef())
                        .withIncluded(os.getIncluded()).withName(os.getName())
                        .withObjid(os.getObjid()).withObjRefPath(os.getObjRefPath())
                        .withStrictArrays(os.getStrictArrays())
                        .withStrictMaps(os.getStrictMaps()).withVer(os.getVer())
                        .withWorkspace(os.getWorkspace()).withWsid(os.getWsid()));
            }
            boolean ignoreErrors = params.getIgnoreErrors() != null && 
                    params.getIgnoreErrors() == 1L;
            GetObjects2Params wsInput = new GetObjects2Params().withObjects(objects)
                    .withIgnoreErrors(ignoreErrors ? 1L : 0L);
            List<us.kbase.workspace.ObjectData> retobjs = wc.getObjects2(wsInput).getData();
            List<ObjectData> results = new ArrayList<>();
            for (us.kbase.workspace.ObjectData o : retobjs) {
                if (o == null) {
                    results.add(null);
                    continue;
                }
                String ref = getRefFromObjectInfo(o.getInfo());
                ObjectData res = null;
                if (o.getHandleError() != null || o.getHandleStacktrace() != null) {
                    String errorMessage = "Handle error for object " + ref;
                    if (o.getHandleError() != null) {
                        errorMessage += ": " + o.getHandleError();
                    }
                    if (o.getHandleStacktrace() != null) {
                        errorMessage += ".\nStacktrace: " + o.getHandleStacktrace();
                    }
                    if (ignoreErrors) {
                        System.out.println(errorMessage);
                        // res (which is null) will be added to results below
                    } else {
                        throw new IllegalStateException(errorMessage);
                    }
                } else {
                    File dataJsonFile = File.createTempFile(
                            "object_" + ref.replace('/', '_') + "_", ".json", tempDir);
                    // Now tempFile contains whole JSON_RPC response. Let's copy part of
                    // tempFile to dataJsonFile.
                    o.getData().getPlacedStream().writeJson(dataJsonFile);
                    res = new ObjectData().withInfo(o.getInfo())
                            .withDataJsonFile(dataJsonFile.getCanonicalPath());
                }
                results.add(res);
            }
            return new GetObjectsResults().withData(results);
        } finally {
            if (tempFile.exists()) {
                tempFile.delete();
            }
        }
    }
    
    public static String getRefFromObjectInfo(Tuple11<Long, String, String, String, 
            Long, String, Long, String, String, Long, Map<String,String>> info) {
        return info.getE7() + "/" + info.getE1() + "/" + info.getE5();
    }
}
