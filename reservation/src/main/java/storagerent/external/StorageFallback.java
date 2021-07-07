
package storagerent.external;

import java.text.SimpleDateFormat;

public class StorageFallback  implements StorageService{
    @Override
    public boolean chkAndReqReserve(long storageId)
    {
        SimpleDateFormat format1 = new SimpleDateFormat ( "yyyy년 MM월dd일 HH시mm분ss초");
                
        String format_time1 = format1.format (System.currentTimeMillis());

        System.out.println("chkAndReqReserve Fall Back Called :" + format_time1);

        return false;
    }
}