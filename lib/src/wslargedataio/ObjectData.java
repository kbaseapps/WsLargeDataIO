
package wslargedataio;

import java.util.HashMap;
import java.util.Map;
import javax.annotation.Generated;
import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
import us.kbase.common.service.Tuple11;


/**
 * <p>Original spec-file type: ObjectData</p>
 * <pre>
 * The data and supplemental info for an object.
 *     UnspecifiedObject data - the object's data or subset data.
 *     object_info info - information about the object.
 * </pre>
 * 
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
@Generated("com.googlecode.jsonschema2pojo")
@JsonPropertyOrder({
    "data_json_file",
    "info"
})
public class ObjectData {

    @JsonProperty("data_json_file")
    private java.lang.String dataJsonFile;
    @JsonProperty("info")
    private Tuple11 <Long, String, String, String, Long, String, Long, String, String, Long, Map<String, String>> info;
    private Map<java.lang.String, Object> additionalProperties = new HashMap<java.lang.String, Object>();

    @JsonProperty("data_json_file")
    public java.lang.String getDataJsonFile() {
        return dataJsonFile;
    }

    @JsonProperty("data_json_file")
    public void setDataJsonFile(java.lang.String dataJsonFile) {
        this.dataJsonFile = dataJsonFile;
    }

    public ObjectData withDataJsonFile(java.lang.String dataJsonFile) {
        this.dataJsonFile = dataJsonFile;
        return this;
    }

    @JsonProperty("info")
    public Tuple11 <Long, String, String, String, Long, String, Long, String, String, Long, Map<String, String>> getInfo() {
        return info;
    }

    @JsonProperty("info")
    public void setInfo(Tuple11 <Long, String, String, String, Long, String, Long, String, String, Long, Map<String, String>> info) {
        this.info = info;
    }

    public ObjectData withInfo(Tuple11 <Long, String, String, String, Long, String, Long, String, String, Long, Map<String, String>> info) {
        this.info = info;
        return this;
    }

    @JsonAnyGetter
    public Map<java.lang.String, Object> getAdditionalProperties() {
        return this.additionalProperties;
    }

    @JsonAnySetter
    public void setAdditionalProperties(java.lang.String name, Object value) {
        this.additionalProperties.put(name, value);
    }

    @Override
    public java.lang.String toString() {
        return ((((((("ObjectData"+" [dataJsonFile=")+ dataJsonFile)+", info=")+ info)+", additionalProperties=")+ additionalProperties)+"]");
    }

}
