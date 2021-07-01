package storagerent;

import javax.persistence.*;
import org.springframework.beans.BeanUtils;
import lombok.Data;

@Data
@Entity
@Table(name="Reservation_table")
public class Reservation {

    @Id
    @GeneratedValue(strategy=GenerationType.AUTO)
    private Long reservationId;
    private Long storageId;
    private String reservationStatus;
    private Long paymentId;
    private Float price;

    @PostPersist
    public void onPostPersist(){
        //ReservationCreated reservationCreated = new ReservationCreated();
        // BeanUtils.copyProperties(this, reservationCreated);
        // reservationCreated.publishAfterCommit();

        // storagerent.external.Storage storage = new storagerent.external.Storage();
        // mappings goes here 
        // Application.applicationContext.getBean(storagerent.external.StorageService.class)
        //    .chkAndReqReserve(storage);

        //------------------
        // 예약이 들어온 경우
        //------------------

        // 해당 STORAGE가 Available한 상태인지 체크
        // storagerent.external.Storage storage = new storagerent.external.Storage();
        // storage.setStorageId(this.getStorageId());

        boolean result = ReservationApplication.applicationContext.getBean(storagerent.external.StorageService.class).chkAndReqReserve(this.getStorageId());
        System.out.println("######## Storage Available Check Result : " + result);
        
        if(result) { 

            // 예약 가능한 상태인 경우(Available)

            //----------------------------
            // PAYMENT 결제 진행 (POST방식)
            //----------------------------
            storagerent.external.Payment payment = new storagerent.external.Payment();
            payment.setReservationId(this.getReservationId());
            payment.setStorageId(this.getStorageId());
            payment.setPaymentStatus("paid");
            payment.setPrice(this.price);
            ReservationApplication.applicationContext.getBean(storagerent.external.PaymentService.class)
                .approvePayment(payment);

            //----------------------------------
            // 이벤트 발행 --> ReservationCreated
            //----------------------------------
            ReservationCreated reservationCreated = new ReservationCreated();
            BeanUtils.copyProperties(this, reservationCreated);
            reservationCreated.publishAfterCommit();
        }

    }

    @PostUpdate
    public void onPostUpdate(){
        if("reqCancel".equals(this.getReservationStatus())) {
            ReservationCancelRequested reservationCancelRequested = new ReservationCancelRequested();
            BeanUtils.copyProperties(this, reservationCancelRequested);
            reservationCancelRequested.publishAfterCommit();
        }

        if("reserved".equals(this.getReservationStatus())) {
            ReservationConfirmed reservationConfirmed = new ReservationConfirmed();
            BeanUtils.copyProperties(this, reservationConfirmed);
            reservationConfirmed.publishAfterCommit();
        }

        if("cancelled".equals(this.getReservationStatus())) {
            ReservationCancelled reservationCancelled = new ReservationCancelled();
            BeanUtils.copyProperties(this, reservationCancelled);
            reservationCancelled.publishAfterCommit();
        }

    }
}
