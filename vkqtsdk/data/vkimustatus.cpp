#include "../vkdata.h"
#include <vkqtsdktypes.h>

Vk_ImuStatus::Vk_ImuStatus(QObject *parent) : QObject(parent) {
    m_scaledImu = new VkScaledImuStatus();
    m_scaledImu->xacc = 0;
    m_scaledImu->yacc = 0;
    m_scaledImu->zacc = 0;
    m_scaledImu->xgyro = 0;
    m_scaledImu->ygyro = 0;
    m_scaledImu->zgyro = 0;
    m_scaledImu->xmag = 0;
    m_scaledImu->ymag = 0;
    m_scaledImu->zmag = 0;
    m_scaledImu->temperature = 0;
}

Vk_ImuStatus::~Vk_ImuStatus() {
    delete m_scaledImu;
}

void Vk_ImuStatus::updateImuData(const VkScaledImuStatus *data) {
    m_scaledImu->xacc = data->xacc;
    m_scaledImu->yacc = data->yacc;
    m_scaledImu->zacc = data->zacc;
    m_scaledImu->xgyro = data->xgyro;
    m_scaledImu->ygyro = data->ygyro;
    m_scaledImu->zgyro = data->zgyro;
    m_scaledImu->xmag = data->xmag;
    m_scaledImu->ymag = data->ymag;
    m_scaledImu->zmag = data->zmag;
    m_scaledImu->temperature = data->temperature;
    emit statusUpdated();
}

float Vk_ImuStatus::systemXacc() { return m_scaledImu->xacc; }
float Vk_ImuStatus::systemYacc() { return m_scaledImu->yacc; }
float Vk_ImuStatus::systemZacc() { return m_scaledImu->zacc; }
float Vk_ImuStatus::systemXgyro() { return m_scaledImu->xgyro; }
float Vk_ImuStatus::systemYgyro() { return m_scaledImu->ygyro; }
float Vk_ImuStatus::systemZgyro() { return m_scaledImu->zgyro; }
float Vk_ImuStatus::systemXmag() { return m_scaledImu->xmag; }
float Vk_ImuStatus::systemYmag() { return m_scaledImu->ymag; }
float Vk_ImuStatus::systemZmag() { return m_scaledImu->zmag; }
float Vk_ImuStatus::systemTemperature() { return m_scaledImu->temperature; }
