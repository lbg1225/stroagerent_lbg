package storagerent;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.lang.reflect.Field;
import sun.misc.Unsafe;

@RestController
public class PaymentController {
    @RequestMapping(value = "/callmemleak",
                    method = RequestMethod.GET,
                    produces = "application/json;charset=UTF-8")
    public void callMemLeak() {
        try {
            this.memLeak();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void memLeak() throws NoSuchFieldException, ClassNotFoundException, IllegalAccessException {
        Class unsafeClass = Class.forName("sun.misc.Unsafe");
        
        Field f = unsafeClass.getDeclaredField("theUnsafe");
        f.setAccessible(true);
        Unsafe unsafe = (Unsafe) f.get(null);
        System.out.print("4..3..2..1...");
        try {
            for(;;)
            unsafe.allocateMemory(1024*1024);
        } catch(Error e) {
            System.out.println("Boom!");
            e.printStackTrace();
        }
    }
}
