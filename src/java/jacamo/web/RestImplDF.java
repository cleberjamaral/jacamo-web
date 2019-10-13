package jacamo.web;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import javax.inject.Singleton;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;

import org.glassfish.jersey.internal.inject.AbstractBinder;

import jason.infra.centralised.BaseCentralisedMAS;

@Singleton
@Path("/services")
public class RestImplDF extends AbstractBinder {

    @Override
    protected void configure() {
        bind(new RestImplDF()).to(RestImplDF.class);
    }

    /** 
     * DF - Directory Facilitator 
     */
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getDFJSON() {
        try {
            Gson gson = new Gson();

            /**
             * Map<String, Set> as a common representation of ZK and BaseCentralisedMAS 
             */
            Map<String, Set<String>> commonDF;
            if (JCMRest.getZKHost() == null) {
                commonDF = BaseCentralisedMAS.getRunner().getDF();
            } else {
                commonDF = new HashMap<String, Set<String>>();

                for (String s : JCMRest.getZKClient().getChildren().forPath(JCMRest.JaCaMoZKDFNodeId)) {
                    for (String a: JCMRest.getZKClient().getChildren().forPath(JCMRest.JaCaMoZKDFNodeId+"/"+s)) {
                        if (!commonDF.containsKey(a)) {
                            Set<String> services = new HashSet<String>();
                            services.add(s);
                            commonDF.put(a,services);
                        } else {
                            commonDF.get(a).add(s);
                        }   
                    }
                }
            }

            /**
             * Following the format suggested in the second example of
             * https://opensource.adobe.com/Spry/samples/data_region/JSONDataSetSample.html
             * 
             * Sample jsonifiedDF: [{"agent":"ag1","services":["s1","s2"]},{"agent":"ag2","services":["s2","s3"]}]
             * Testing platform: http://json.parser.online.fr/
             */
            Map<String, Set<String>> sortedCommonDF = new TreeMap<>(commonDF);          
            Set<Object> jsonifiedDF = new HashSet<Object>();
            for (String s : sortedCommonDF.keySet()) {
                Map<String, Object> agent = new HashMap<String, Object>();
                agent.put("agent", s);
                Set<String> services = new HashSet<>();
                services.addAll(sortedCommonDF.get(s)); 
                agent.put("services", services);
                jsonifiedDF.add(agent);
            }
            
            return Response.ok().entity(gson.toJson(jsonifiedDF)).header("Access-Control-Allow-Origin", "*").build();

        } catch (Exception e) {
            e.printStackTrace();
        }

        /* 500 Internal Server Error - https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html */
        return Response.status(500).build();
    }

}
