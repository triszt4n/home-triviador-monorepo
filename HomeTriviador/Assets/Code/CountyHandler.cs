using System;
using System.Collections;
using System.Text;
using UnityEngine;
using UnityEngine.Networking;

namespace Code
{
    public class CountyHandler : MonoBehaviour
    {
        public void ChooseCounty(int index) 
        {
            Debug.Log("Chosen:" + index);
            var playerName = PlayerPrefs.GetString("playerName");
            StartCoroutine(Conquer(playerName, index));
        }
    
        [Serializable]
        public class PostData {
            public string name;
            public int countyIndex;
        }

        private IEnumerator Conquer(string playerName, int countyIndex)
        {
            var request = new UnityWebRequest("http://localhost:3000/game/conquer", "POST");
            var bodyRaw = Encoding.UTF8.GetBytes(JsonUtility.ToJson(new PostData { name = playerName, countyIndex = countyIndex }));
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");
            yield return request.SendWebRequest();
            if (request.result != UnityWebRequest.Result.Success) 
            {
                Debug.LogError("Enter failed: " + request.error);
            }
            else
            {
                var handler = GameObject.FindGameObjectWithTag("Canvas").GetComponent<GameHandler>();
                handler.toConcquer = Math.Max(handler.toConcquer - 1, 0);
            }
        }
    
        // Start is called once before the first execution of Update after the MonoBehaviour is created
        void Start()
        {
        
        }

        // Update is called once per frame
        void Update()
        {
        
        }
    }
}
