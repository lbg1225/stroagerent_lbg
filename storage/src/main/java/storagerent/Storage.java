package storagerent;

import java.lang.*;

import javax.persistence.*;
import org.springframework.beans.BeanUtils;
import lombok.Data;

@Data
@Entity
@Table(name="Storage_table")
public class Storage {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long storageId;
    private String storageStatus;
    private String description;
    private Long reviewCnt;
    private String lastAction;
    private Float price;

    @PostPersist
    public void onPostPersist(){
    /*  try {
            Thread.currentThread().sleep((long) (800 + Math.random() * 220));
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    */
        StorageRegistered storageRegistered = new StorageRegistered();
        BeanUtils.copyProperties(this, storageRegistered);
        storageRegistered.publishAfterCommit();


    }

    @PostUpdate
    public void onPostUpdate(){
        if("modify".equals(lastAction) || "review".equals(lastAction)) {
            StorageModified storageModified = new StorageModified();
            BeanUtils.copyProperties(this, storageModified);
            storageModified.publishAfterCommit();
        }

        if("reserved".equals(lastAction)) {
            StorageReserved storageReserved = new StorageReserved();
            BeanUtils.copyProperties(this, storageReserved);
            storageReserved.publishAfterCommit();
        }

        if("cancelled".equals(lastAction)) {
            StorageCancelled storageCancelled = new StorageCancelled();
            BeanUtils.copyProperties(this, storageCancelled);
            storageCancelled.publishAfterCommit();
        }

    }

    @PreRemove
    public void onPreRemove(){
        StorageDeleted storageDeleted = new StorageDeleted();
        BeanUtils.copyProperties(this, storageDeleted);
        storageDeleted.publishAfterCommit();
    }
}
