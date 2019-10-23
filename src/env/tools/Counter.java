// CArtAgO artifact code for project jcmrest3

package tools;

import cartago.*;

@ARTIFACT_INFO(outports = { @OUTPORT(name = "out-1") })

public class Counter extends Artifact {
    void init(int initialValue) {
        defineObsProperty("count", initialValue);
    }

    @OPERATION
    void inc() {
        ObsProperty prop = getObsProperty("count");
        prop.updateValue(prop.intValue()+1);
        signal("tick");
    }
}

