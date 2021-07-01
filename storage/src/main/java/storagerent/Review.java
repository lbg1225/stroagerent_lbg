package storagerent;

import javax.persistence.*;
import org.springframework.beans.BeanUtils;
import lombok.Data;

@Data
@Entity
@Table(name="Review_table")
public class Review {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long reviewId;
    private Long storageId;
    private Integer rate;
    private String content;

    @PostPersist
    public void onPostPersist(){
        ReviewCreated reviewCreated = new ReviewCreated();
        BeanUtils.copyProperties(this, reviewCreated);
        reviewCreated.publishAfterCommit();


    }

    @PostUpdate
    public void onPostUpdate(){
        ReviewModified reviewModified = new ReviewModified();
        BeanUtils.copyProperties(this, reviewModified);
        reviewModified.publishAfterCommit();


    }

    @PreRemove
    public void onPreRemove(){
        ReviewDeleted reviewDeleted = new ReviewDeleted();
        BeanUtils.copyProperties(this, reviewDeleted);
        reviewDeleted.publishAfterCommit();
    }
}
