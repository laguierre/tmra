function cargar(){
          var link = document.createElement('a');
          link.setAttribute('href', '/download.html?inf='+document.getElementById('limInf').value+'&sup='+document.getElementById('limSup').value);
          link.setAttribute('download', 'EM0_20000101.raw');
          link.setAttribute('target', '_blank');
          link.style.display = 'none';
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);console.log(link);
        };