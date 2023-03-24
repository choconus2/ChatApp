class LinkUrlImage{

  static String urlImageUserDefault= "https://media.istockphoto.com/id/1337144146/vector/default-avatar-profile-icon-vector.jpg?s=612x612&w=0&k=20&c=BIbFwuv7FxTWvh5S3vB6bkT0Qv8Vn8N5Ffseq84ClGI=";

  static String urlImage(String nameImage){
    return "https://firebasestorage.googleapis.com/v0/b/chatapp-5e05f.appspot.com/o/files%2F$nameImage?alt=media&token=008f2cf1-d291-4429-88a5-33db7aa0ad82";
  }

}