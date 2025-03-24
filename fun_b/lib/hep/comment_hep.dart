import 'package:fun_b/dialog/comment/comment_dialog.dart';
import 'package:fun_b/dialog/comment/comment_success/comment_success_dialog.dart';
import 'package:fun_b/hep/storage/storage_bean.dart';
import 'package:fun_base/routers/routers_utils.dart';
import 'package:in_app_review/in_app_review.dart';

class CommentHep{
  static final CommentHep _instance=CommentHep();
  static CommentHep get instance => _instance;

  showCommentDialog(){
    if(goodComment.getData()){
      return;
    }
    RouterUtils.dialog(
      widget: CommentDialog(
        dismiss: (star)async{
          goodComment.saveData(true);
          if(star<=2){
            RouterUtils.dialog(widget: CommentSuccessDialog());
          }else{
            var instance = InAppReview.instance;
            var isAvailable = await instance.isAvailable();
            if(isAvailable){
              instance.requestReview();
            }
          }
        },
      ),
    );
  }
}