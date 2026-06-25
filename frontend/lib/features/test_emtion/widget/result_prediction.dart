
String resultPrediction(String emotion) {
  if (emotion == 'Vui vẻ') {
    return 'Hiện tại bạn đang có trang thái rất tốt';
  }
  if (emotion == 'Bình thường') {
    return 'Hiện tại bạn đang trong trạng thái tâm lý ổn định';
  }
  if (emotion == 'Buồn bã') {
    return 'Hiện tại bạn đang trong trạng thái tâm lý hơi buồn bã';
  }
  if (emotion == 'Giận dữ') {
    return 'Hiện tại bạn đang trong trạng thái tâm lý căng thẳng';
  }
  if (emotion == 'Lo lắng') {
    return 'Hiện tại bạn đang trong trạng thái tâm lý lo lắng';
  }
  return 'Hiện tại bạn đang trong trạng thái tâm lý không ổn định';
}
