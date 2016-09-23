package wslargedataio;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import us.kbase.auth.AuthToken;
import us.kbase.common.service.Tuple11;
import us.kbase.common.service.UObject;
import us.kbase.workspace.WorkspaceClient;

public class WsLargeDataIOImpl {

    public static List<Tuple11<Long, String, String, String, Long, String, Long, String, String, Long, Map<String,String>>> 
    saveObjects(SaveObjectsParams params, AuthToken token, Map<String, String> config) throws Exception {
        WorkspaceClient wc = new WorkspaceClient(new URL(config.get("workspace-url")), token);
        wc.setIsInsecureHttpConnectionAllowed(true);
        List<us.kbase.workspace.ObjectSaveData> objects = 
                new ArrayList<us.kbase.workspace.ObjectSaveData>();
        for (ObjectSaveData osd : params.getObjects()) {
            File file = new File(osd.getDataJsonFile());
            objects.add(
                    new us.kbase.workspace.ObjectSaveData().withType(osd.getType())
                    .withData(new UObject(file)).withHidden(osd.getHidden())
                    .withMeta(osd.getMeta()).withName(osd.getName())
                    .withObjid(osd.getObjid()));
        }
        us.kbase.workspace.SaveObjectsParams soParams = 
                new us.kbase.workspace.SaveObjectsParams().withId(params.getId())
                .withWorkspace(params.getWorkspace())
                .withObjects(objects);
        return wc.saveObjects(soParams);
    }

    public static GetObjectsResults getObjects(GetObjectsParams params, AuthToken token, Map<String, String> config) throws Exception {
        throw new IllegalStateException("Not implemented yet");
    }
}
