package storagerent;

import storagerent.config.kafka.KafkaProcessor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.stream.annotation.StreamListener;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
public class PolicyHandler{
    @Autowired StorageRepository storageRepository;
    @Autowired ReviewRepository reviewRepository;

    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReviewCreated_UpdateReviewCnt(@Payload ReviewCreated reviewCreated){

        if(!reviewCreated.validate()) return;

        System.out.println("\n\n##### listener UpdateReviewCnt : " + reviewCreated.toJson() + "\n\n");

        updateReviewCnt(reviewCreated.getStorageId(), +1); // 리뷰건수 증가
            
    }
    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReviewDeleted_UpdateReviewCnt(@Payload ReviewDeleted reviewDeleted){

        if(!reviewDeleted.validate()) return;

        System.out.println("\n\n##### listener UpdateReviewCnt : " + reviewDeleted.toJson() + "\n\n");

        
        updateReviewCnt(reviewDeleted.getStorageId(), -1); // 리뷰건수 감소    
            
    }
    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReservationConfirmed_ConfirmReserve(@Payload ReservationConfirmed reservationConfirmed){

        if(!reservationConfirmed.validate()) return;

        System.out.println("\n\n##### listener ConfirmReserve : " + reservationConfirmed.toJson() + "\n\n");

        updateStorageStatus(reservationConfirmed.getStorageId(), "reserved", "reserved"); // Status Update
    }
    @StreamListener(KafkaProcessor.INPUT)
    public void wheneverReservationCancelled_Cancel(@Payload ReservationCancelled reservationCancelled){

        if(!reservationCancelled.validate()) return;

        System.out.println("\n\n##### listener Cancel : " + reservationCancelled.toJson() + "\n\n");

        updateStorageStatus(reservationCancelled.getStorageId(), "available", "cancelled"); // Status Update  
    }


    @StreamListener(KafkaProcessor.INPUT)
    public void whatever(@Payload String eventString){}

    private void updateReviewCnt(long storageId, long num)     {

        //////////////////////////////////////////////
        // roomId 룸 데이터의 ReviewCnt를 num 만큼 가감
        //////////////////////////////////////////////

        // Room 테이블에서 roomId의 Data 조회 -> room
        Optional<Storage> res = storageRepository.findById(storageId);
        Storage storage = res.get();

        // room 값 수정
        storage.setReviewCnt(storage.getReviewCnt() + num); // 리뷰건수 증가/감소
        storage.setLastAction("review");  // lastAction 값 셋팅

        System.out.println("Edited reviewCnt : " + storage.getReviewCnt());
        System.out.println("Edited lastAction : " + storage.getLastAction());

        /////////////
        // DB Update
        /////////////
        storageRepository.save(storage);

    }

        
    private void updateStorageStatus(long storageId, String storageStatus, String lastAction)     {

        //////////////////////////////////////////////
        // roomId 룸 데이터의 status, lastAction 수정
        //////////////////////////////////////////////

        // Room 테이블에서 roomId의 Data 조회 -> room
        Optional<Storage> res = storageRepository.findById(storageId);
        Storage storage = res.get();

        // room 값 수정
        storage.setStorageStatus(storageStatus); // status 수정 
        storage.setLastAction(lastAction);  // lastAction 값 셋팅

        System.out.println("Edited status     : " + storage.getStorageStatus());
        System.out.println("Edited lastAction : " + storage.getLastAction());

        /////////////
        // DB Update
        /////////////
        storageRepository.save(storage);

    }

}
