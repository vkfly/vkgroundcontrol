package org.mavlink.qgroundcontrol

import android.util.Log
import com.vkfly.rcsdk.controller.IController
import java.net.DatagramPacket
import java.net.DatagramSocket
import java.net.SocketAddress
import java.util.concurrent.ConcurrentLinkedDeque

class UdpBridge(private val port: Int, private val controller: IController) : Thread() {

    private val TAG = "UdpBridge"

    private val queue = ConcurrentLinkedDeque<ByteArray>()
    private var stop = false
    private var clientAddress: SocketAddress? = null

    init {
        start()
    }

    // RC -> client
    fun send(data: ByteArray) = queue.add(data)

    fun stopServer() {
        stop = true
    }

    private fun send(udp: DatagramSocket) {
        if (clientAddress == null) {
            queue.clear()
            return
        }
        var data = queue.poll()
        while (data != null) {
            val packet = DatagramPacket(data, data.size, clientAddress!!)
            udp.send(packet)
            data = queue.poll()
        }
    }

    override fun run() {
        val udp: DatagramSocket
        try {
            udp = DatagramSocket(port)
        } catch (e: Exception) {
            Log.e(TAG, "bridge failed: $e")
            return
        }

        udp.soTimeout = 50
        val buf = ByteArray(1024)
        val packet = DatagramPacket(buf, 1024)
        Log.d(TAG, "udp socket start on $port")
        while (!stop) {
            try {
                udp.receive(packet)
                clientAddress = packet.socketAddress
                if (packet.length > 0) {
                    val data = ByteArray(packet.length)
                    System.arraycopy(buf, 0, data, 0, packet.length)
                    controller.sendRadio(0, data)
                }
            } catch (e: Exception) {
            }
            send(udp)
        }
        udp.close()
    }
}
