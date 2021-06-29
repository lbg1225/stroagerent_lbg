
package storagerent.external;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@FeignClient(name="Storage", url="${prop.storage.url}")
public interface StorageService {

    @RequestMapping(method=RequestMethod.GET, path="/check/chkAndReqReserve")
    public boolean chkAndReqReserve(@RequestParam("storageId") long storageId);
}