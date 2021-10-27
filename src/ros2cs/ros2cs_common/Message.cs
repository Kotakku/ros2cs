// Copyright 2019-2021 Robotec.ai
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

using System;

namespace ROS2
{
  /// <summary> Basic Message interface, only exposing Dispose method <summary>
  public interface Message : IExtendedDisposable
  {
  }

  /// <summary> Convenience interface to manipulate headers <summary>
  public interface MessageWithHeader : Message
  {
    void SetHeaderFrame(string frameID);
    string GetHeaderFrame();
    void UpdateHeaderTime(int sec, uint nanosec);
  }
}  // namespace ROS2
