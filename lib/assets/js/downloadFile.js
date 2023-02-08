function sendToDownload(int limInf, int limSup, String url){
    var link = document.createElement('a');

    link.setAttribute('href', 'http://192.168.4.1/download.html?inf=' + limInf +'&sup=' limSup);
    link.setAttribute('download', 'EM0_20000101.raw');
    link.setAttribute('target', '_blank');
    //link.style.display = 'none';
    //document.body.appendChild(link);
    link.click();
    //document.body.removeChild(link);
}